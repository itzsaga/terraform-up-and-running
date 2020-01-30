provider "aws" {
  region    = "us-east-1"
  profile   = "seth-terraform"
}

resource "aws_instance" "example" {
  ami                       = "ami-07ebfd5b3428b6f4d"
  instance_type             = "t2.micro"
  vpc_security_group_ids    = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  tags = {
      Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
      from_port     = var.server_port
      to_port       = var.server_port
      protocol      = "tcp"
      cidr_blocks   = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP request"
  type        = number
  default     = 8080
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the web server"
}
