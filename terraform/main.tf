terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "database" {
  source       = "./modules/database"
  project_name = var.project_name
  environment  = var.environment
}

module "api" {
  source               = "./modules/api"
  project_name         = var.project_name
  environment          = var.environment
  dynamodb_table_name  = module.database.table_name
  dynamodb_table_arn   = module.database.table_arn
}