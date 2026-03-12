data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "devsecops-web-sg"
  description = "Security group for DevSecOps assignment"

  # Keep only the web app port publicly accessible
  ingress {
    description = "Allow public access to web application on port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-web-sg"
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Enforce IMDSv2
  metadata_options {
    http_tokens = "required"
  }

  # Encrypt the root volume
  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "devsecops-assignment-server"
  }
}