provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ssh" {
  name = "allow-ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # restrict to your IP in real use
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "free_tier_ec2" {
  ami           = var.ami_id
  instance_type = "t3.micro"   # ✅ Free tier
  key_name      = var.key_name
  security_groups = [aws_security_group.ssh.name]

  tags = {
    Name = "amazon-linux-free-tier"
  }

  # Copy file to EC2
  provisioner "file" {
    source      = "files/hello.txt"
    destination = "/home/ec2-user/hello.txt"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  # Optional: run command
  provisioner "remote-exec" {
    inline = [
      "cat /home/ec2-user/hello.txt"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}