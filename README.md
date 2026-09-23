import json
import os
import uuid
import boto3

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('TABLE_NAME')
table = dynamodb.Table(table_name) if table_name else None

def build_response(status_code, body):
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(body)
    }

def handler(event, context):
    if not table:
        return build_response(500, {'error': 'TABLE_NAME environment variable not set'})

    http_method = event.get('requestContext', {}).get('http', {}).get('method')
    path = event.get('requestContext', {}).get('http', {}).get('path', '')

    try:
        # GET /items or GET /items/{id}
        if http_method == 'GET':
            path_parameters = event.get('pathParameters', {})
            if path_parameters and 'proxy' in path_parameters:
                item_id = path_parameters['proxy'].split('/')[-1]
                response = table.get_item(Key={'id': item_id})
                item = response.get('Item')
                if not item:
                    return build_response(404, {'message': f'Item {item_id} not found'})
                return build_response(200, item)
            else:
                response = table.scan()
                return build_response(200, response.get('Items', []))

        # POST /items
        elif http_method == 'POST':
            raw_body = event.get('body', '{}')
            body = json.loads(raw_body) if raw_body else {}
            
            item_id = body.get('id', str(uuid.uuid4()))
            item_name = body.get('name', 'Untitled Item')
            
            item = {
                'id': item_id,
                'name': item_name
            }
            
            table.put_item(Item=item)
            return build_response(201, {'message': 'Item created', 'item': item})

        # DELETE /items/{id}
        elif http_method == 'DELETE':
            path_parameters = event.get('pathParameters', {})
            if path_parameters and 'proxy' in path_parameters:
                item_id = path_parameters['proxy'].split('/')[-1]
                table.delete_item(Key={'id': item_id})
                return build_response(200, {'message': f'Item {item_id} deleted successfully'})
            return build_response(400, {'error': 'Missing item ID in path'})

        return build_response(400, {'error': f'Unsupported method: {http_method}'})

    except Exception as e:
        return build_response(500, {'error': str(e)})