provider "aws" {
  region = "us-east-1"
}


resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow traffic to backend and database"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP (Nginx)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Node.js (Backend)"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow MongoDB (optional)"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-00a929b66ed6e0de6"  
  instance_type = "t2.micro"
  key_name      = "your-key-pair"
  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              
            sudo yum update -y
            sudo yum install -y docker git
            sudo service docker start
            sudo usermod -aG docker ec2-user
            sudo chmod 666 /var/run/docker.sock

            sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose

            cd /home/ec2-user
            git clone https://github.com/aradhyadengre/node-mongo-deployment.git my-project
            cd my-project
            docker-compose up -d --build

            EOF

  tags = {
    Name = "NodeJS-App-Server"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}







































# provider "aws" {
#   region = "us-east-1"
#   profile = "aradhya"
# }

# resource "aws_instance" "app_server" {
#   ami           = "ami-0abcdef1234567890"
#   instance_type = "t2.micro"
#   key_name      = "mykey"

#   user_data = <<-EOF
#               #!/bin/bash
#               yum install -y docker
#               service docker start
#               usermod -aG docker ec2-user
#               docker run -d -p 80:80 capslock2806/devops-backend
#               EOF

#   tags = {
#     Name = "TerraformNodeApp"
#   }
# }

# output "public_ip" {
#   value = aws_instance.app_server.public_ip
# }


