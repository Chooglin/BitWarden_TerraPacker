terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "bitwarden" {
  ami           = data.aws_ami.get_ami.id
  vpc_security_group_ids = [aws_security_group.instance.id]
  instance_type = "t2.micro"
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo docker run -d --name bitwarden -v /bw-data/:/data/ -p 80:80 bitwardenrs/server:latest
                  EOF

  tags = {
    Name = "bitwarden"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
