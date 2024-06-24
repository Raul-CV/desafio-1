# asignar la region
provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "servidor-nginx" {
  ami           = "ami-032598fcc7e9d1c7a" 
  instance_type = "t2.micro"

  tags = {
    Name = "desafio1.3"
  }

  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo amazon-linux-extras install nginx1 -y
            sudo systemctl start nginx
            sudo systemctl enable nginx
           cat <<EOT > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Desafio1</title>
    <style>
        body {
            text-align: center;
            font-family: Arial, sans-serif;
        }
        img {
            display: block;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <h1>Hola mundo</h1>
    <p>se muestra el html del desafio 1 en aws</p>
    <img src="https://media1.tenor.com/m/3uKrlh92ZVUAAAAd/mapache-pedro-mapache.gif" 
    alt="Pedro GIF" width="100" height="150">
</body>
</html>
EOT
  EOF

  # Para acceder a través de SSH e HTTP
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
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