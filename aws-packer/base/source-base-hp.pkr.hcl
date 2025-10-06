source "amazon-ebs" "basehp-linux" {
  ami_name      = "basehp-linux"
  instance_type = "t3.micro"
  region        = "eu-north-1"
  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }
  ssh_username = "ec2-user"

}