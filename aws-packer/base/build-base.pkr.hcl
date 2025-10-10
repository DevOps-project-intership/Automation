build {
    name = "base-ami"
    sources = ["source.amazon-ebs.basehp-linux"]

    provisioner "shell" {
        script = "scripts/base-tools.sh"
    }

    provisioner "shell" {
        script = "scripts/install-lynis.sh"
    }

    provisioner "shell" {
        script = "scripts/install-consul.sh"
    }

    provisioner "file" {
        source = "additional-files/consul-dns.conf"
        destination = "/tmp/consul.conf"
    }

    provisioner "shell" {
        script = "scripts/setup-consul-dns.sh"
    }
}