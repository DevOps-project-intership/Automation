
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


module "jenkins" {
  source            = "./modules/ec2"
  name              = "jenkins"
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = var.instance_type
  ssh_key_name      = var.ssh_key_name
}

module "consul" {
  source            = "./modules/ec2"
  name              = "consul"
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = var.instance_type
  ssh_key_name      = var.ssh_key_name
}

module "flask" {
  source            = "./modules/ec2"
  name              = "flask"
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = var.instance_type
  ssh_key_name      = var.ssh_key_name
}

module "db" {
  source            = "./modules/ec2"
  name              = "database"
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = var.instance_type
  ssh_key_name      = var.ssh_key_name
}

module "lb" {
  source            = "./modules/ec2"
  name              = "loadbalancer"
  ami_id            = data.aws_ami.amazon_linux_2.id
  instance_type     = var.instance_type
  ssh_key_name      = var.ssh_key_name
}
