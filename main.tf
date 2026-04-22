provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "bgv_sg" {
  name = "bgv-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

resource "aws_instance" "bgv_ec2" {
  ami                         = var.ami_id
  instance_type              = "t3.micro"
  key_name                   = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids     = [aws_security_group.bgv_sg.id]

  user_data = file("user-data.sh")

  tags = {
    Name = "bgv-app"
  }
  
  
  provisioner "file" {
  source      = "./app"
  destination = "/home/ec2-user/app"  
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
}


  
  
}