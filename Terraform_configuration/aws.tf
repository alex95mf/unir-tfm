# Recurso de bucket S3
resource "aws_s3_bucket" "my_bucket" {
  bucket = "unir-tesis-bucket-unico"
  acl    = "private"
}

# Politica de IAM para acceso a S3
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy to allow EC2 instances to access S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::unir-tesis-bucket-unico",
          "arn:aws:s3:::unir-tesis-bucket-unico/*"
        ]
      }
    ]
  })
}

# Rol de IAM para EC2
resource "aws_iam_role" "ec2_role" {
  name               = "EC2S3AccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Adjuntar la politica de IAM al rol
resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Perfil de instancia de IAM para EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}

# Recurso de grupo de seguridad
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Recurso de instancia EC2
resource "aws_instance" "web_server" {
  ami                    = "ami-02d531920f6c4da36"  # AMI de Ubuntu 20.04 LTS
  instance_type         = var.selected_hardware
  iam_instance_profile  = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "Web Server"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y unzip awscli apache2
    sudo mkdir -p /var/www/html
    sudo aws s3 cp s3://unir-tesis-bucket-unico/ /var/www/html/ --recursive
    sudo systemctl restart apache2
  EOF

  vpc_security_group_ids = [aws_security_group.web_sg.id]
}