# Importa la plantilla de configuración AWS
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

# Utiliza la plantilla de configuración para definir recursos
data "template_file" "aws_config" {
  template = file("./aws.tf.template")

  vars = {
    selected_hardware = var.selected_hardware
  }
}

variable "selected_hardware" {
  description = "Tipo de hardware seleccionado"
  type        = string
  default     = "t2.micro"  # Valor predeterminado
}

variable "access_key" {
  description = "Access Key"
  type        = string
  default     = "default_value"
}

variable "secret_key" {
  description = "Secret Key"
  type        = string
  default     = "default_value"
}

