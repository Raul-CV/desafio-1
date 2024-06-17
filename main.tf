# asignar la region
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "servidor-nginx" {
  ami           = "ami-06373f703eb245f45"
  instance_type = "t2.micro"

  tags = {
    Name = "NginxServer"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "echo 'Hello World' | sudo tee /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"  # Cambia esto según el AMI que estés usando
      private_key = file("fpY8ovQbvH5TthEY21i7rjvkLEDatcv4aCtfZAg0JSk")  # Ruta a tu clave privada
      host        = aws_instance.servidor-nginx.public_ip
    }
  }
}

output "public_ip" {
  value = aws_instance.servidor-nginx.public_ip
}