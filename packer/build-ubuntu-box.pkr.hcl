packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }

  required_plugins {
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}


variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
}

variable "ssh_private_key_file" {
  type = string
}

variable "ssh_username" {
  type    = string
  default = "vagrant"
}

locals {
  vm_name = "ubuntu-vagrant-packer"
}


source "virtualbox-iso" "ubuntu" {
  guest_os_type          = "Ubuntu_64"
  vm_name                = local.vm_name
  iso_url                = var.iso_url
  iso_checksum           = var.iso_checksum
  communicator           = "ssh"
  ssh_username           = var.ssh_username
  ssh_private_key_file   = var.ssh_private_key_file
  ssh_timeout            = "30m"
  http_directory         = "http"
  shutdown_command       = "echo vagrant | sudo -S shutdown -P now"

  disk_size              = 20480
  boot_wait              = "5s"
  headless               = true

  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<enter>",
    "<f10>"
  ]

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "2048"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--vram", "16"]
  ]
}


build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init...'",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "echo 'Cloud-init finished!'",
      "sudo cloud-init clean",
      "echo 'Removing temporary VBoxGuestAdditions.iso if exists...'",
      "rm -f ~/VBoxGuestAdditions.iso",
      "echo 'Ubuntu 22.04 Packer box ready!'"
    ]
  }

  post-processor "vagrant" {
    output = "ubuntu-vagrant.box"
  }
}
