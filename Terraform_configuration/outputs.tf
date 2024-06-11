output "selected_hardware" {
  value = module.aws_resources.selected_hardware
}

output "s3_bucket" {
  value = module.aws_resources.s3_bucket
}

output "instance_name" {
  value = module.aws_resources.instance_name
}

output "min_instances" {
  value = module.aws_resources.min_instances
}

output "desired_instances" {
  value = module.aws_resources.desired_instances
}

output "max_instances" {
  value = module.aws_resources.max_instances
}
