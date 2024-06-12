variable "access_key" {
  description = "Access Key"
  type        = string
}

variable "secret_key" {
  description = "Secret Key"
  type        = string
}

variable "selected_hardware" {
  description = "Selected hardware type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 Instance Name"
  type        = string
  default     = "web-server"
}

variable "s3_bucket" {
  description = "S3 Bucket Name"
  type        = string
  default     = "unir-tesis-s3"
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "desired_instances" {
  description = "Desired number of instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
