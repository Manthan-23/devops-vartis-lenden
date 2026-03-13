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
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3

              mkdir -p /home/ec2-user/app
              cat <<HTML > /home/ec2-user/app/index.html
              <html>
                <head><title>DevOps Assignment-Vartis Platform</title></head>
                <body style="font-family: Arial; text-align: center; margin-top: 50px;">
                  <h1>DevOps Assignment(Vartis Platform) - App Running</h1>
                  <p>Deployed securely on AWS EC2 via Terraform by Manthan Nanaware</p>
                </body>
              </html>
HTML

              cd /home/ec2-user/app
              nohup python3 -m http.server 3000 --bind 0.0.0.0 > /var/log/app.log 2>&1 &
              EOF

  tags = {
    Name = "devsecops-assignment-server"
  }
}