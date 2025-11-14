source "amazon-ebs" "basehp-linux" {
  ami_name      = "basehp-linux"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-kernel-6.1-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }

  launch_block_device_mappings {
  device_name           = "/dev/xvda"
  volume_size           = 8
  volume_type           = "gp3"
  delete_on_termination = true
}

ami_block_device_mappings {
  device_name           = "/dev/xvda"
  volume_size           = 8
  volume_type           = "gp3"
  delete_on_termination = true
}
  ssh_username = "ec2-user"

}