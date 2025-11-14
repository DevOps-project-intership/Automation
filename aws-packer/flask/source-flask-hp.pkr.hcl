source "amazon-ebs" "flaskhp-linux" {
  ami_name      = "flaskhp-linux"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "basehp-linux"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["037490753541"]
  }
  ssh_username = "ec2-user"

}
