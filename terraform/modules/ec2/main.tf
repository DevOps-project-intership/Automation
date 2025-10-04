variable "name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "ssh_key_name" { type = string }

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  associate_public_ip_address = true

  tags = {
    Name = var.name
  }
}

output "id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
