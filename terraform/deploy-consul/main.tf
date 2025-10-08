
provider "aws" {
  region = "eu-north-1"
}


resource "aws_instance" "consul" {
  ami                    = "ami-0a410d510ebdc48ba"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_ids[0]
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg_id]
  
  associate_public_ip_address = false

  tags = { 
    Name = "Consul" 
  }
}