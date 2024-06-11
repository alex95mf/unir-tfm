variable "selected_hardware" {
  description = "Selected hardware type"
  type        = string
}

variable "instance_name" {
  description = "EC2 Instance Name"
  type        = string
}

variable "s3_bucket" {
  description = "S3 Bucket Name"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
}

variable "desired_instances" {
  description = "Desired number of instances"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
}