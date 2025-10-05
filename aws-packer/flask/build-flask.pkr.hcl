build {
  name    = "hpflask-ami"
  sources = ["source.amazon-ebs.flaskhp-linux"]


  provisioner "shell" {
    script = "scripts/install-python.sh"
  }

  provisioner "ansible" {
    playbook_file = "ansible/flask.yml"
    user          = "ec2-user"
  }
}