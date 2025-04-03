provider "aws" {
  region = "us-east-1"
  profile = "aradhya"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  key_name      = "mykey"

  user_data = <<-EOF
              #!/bin/bash
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user
              docker run -d -p 80:80 capslock2806/devops-backend
              EOF

  tags = {
    Name = "TerraformNodeApp"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}
