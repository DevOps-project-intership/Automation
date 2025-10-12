source "amazon-ebs" "flaskhp-linux" {
  ami_name      = "flaskhp-linux-v3"
  instance_type = "t3.micro"
  region        = "eu-north-1"
  subnet_id     = "subnet-0ec2362a134b1fbf4"
  source_ami_filter {
    filters = {
      name                = "basehp-linux-v3"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["272117125309"]
  }
  ssh_username = "ec2-user"

}
