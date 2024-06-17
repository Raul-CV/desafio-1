# asignar la region
provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "servidor-nginx" {
  ami           = "ami-032598fcc7e9d1c7a" 
  instance_type = "t2.micro"

  tags = {
    Name = "NginxServer3"
  }

  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo amazon-linux-extras install nginx1 -y
            sudo systemctl start nginx
            sudo systemctl enable nginx
            echo "Hello World" | sudo tee /usr/share/nginx/html/index.html
  EOF

  # Para acceder a través de SSH e HTTP
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update",
#       "sudo apt install -y nginx",
#       "echo 'Hello World' | sudo tee /var/www/html/index.html"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ec2-user"  # Cambia esto según el AMI que estés usando
#       private_key = file("fpY8ovQbvH5TthEY21i7rjvkLEDatcv4aCtfZAg0JSk")  # Ruta a tu clave privada
#       host        = aws_instance.servidor-nginx.public_ip
#     }
#   }
}

resource "aws_security_group" "nginx_sg" {
  name_prefix = "nginx-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

output "public_ip" {
  value = aws_instance.servidor-nginx.public_ip
}