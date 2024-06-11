terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "aws_resources" {
  source = "./modules/aws_resources"

  selected_hardware = var.selected_hardware
  instance_name     = var.instance_name
  s3_bucket         = var.s3_bucket
  desired_instances = var.desired_instances
  min_instances     = var.min_instances
  max_instances     = var.max_instances
}
