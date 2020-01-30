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
              nohup busybox http -f -p 8080 &
              EOF

  tags = {
      Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
      from_port     = 8080
      to_port       = 8080
      protocol      = "tcp"
      cidr_blocks   = ["0.0.0.0/0"]
  }
}
