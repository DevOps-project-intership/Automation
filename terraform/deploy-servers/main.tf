
provider "aws" {
  region = "eu-north-1"
}


resource "aws_instance" "database" {
  ami                    = "ami-0a410d510ebdc48ba"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_ids[0]
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = false

  tags = { 
    Name = "Database"
  }
}


resource "aws_instance" "flask-1" {
  ami                    = "ami-08a686a69a7bf216e"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_ids[1]
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = false

  tags = { 
    Name = "Flask Server 1" 
  }
}

resource "aws_instance" "flask-2" {
  ami                    = "ami-08a686a69a7bf216e"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_ids[3]
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = false

  tags = { 
    Name = "Flask Server 2" 
  }
}


resource "aws_instance" "loadbalancer" {
  ami                    = "ami-0a410d510ebdc48ba"
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  
  associate_public_ip_address = true

  tags = {
    Name = "Load Balancer" 
  }
}


resource "aws_instance" "consul" {
  ami                    = "ami-0a410d510ebdc48ba"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_ids[4]
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  
  associate_public_ip_address = false

  tags = { 
    Name = "Consul" 
  }
}