# Ubuntu Vagrant Box with Packer

This is **Packer configuration** to automatically build a customized Ubuntu Vagrant Box using **VirtualBox**.

## What's Inside

- **Ubuntu 22.04.5 Live Server** (ISO downloaded automatically).
- Automated installation via **cloud-init autoinstall**.
- Installed packages:
  - `sudo`
  - `openssh-server`
  - `python3`, `python3-pip`
  - `nginx`
  - `net-tools`
  - `curl`
- Pre-configured **`vagrant`** user:
  - SSH keys for login.
  - Password login disabled (`allow-pw: false`).
  - **Passwordless sudo** privileges.


## Configuration Variables

| Variable              | Description                          |
|------------------------|--------------------------------------|
| `iso_url`              | Ubuntu ISO download link.            |
| `iso_checksum`         | SHA256 checksum for the ISO.         |
| `ssh_private_key_file` | Path to your SSH private key.        |
| `ssh_username`         | SSH user (default: `vagrant`).       |
| `vm_name`              | Virtual machine name.                |

## Requirements

Make sure you have the following installed:
- [Packer](https://developer.hashicorp.com/packer) ≥ 1.10
- [VirtualBox](https://www.virtualbox.org/) ≥ 7.0
- [Vagrant](https://www.vagrantup.com/) ≥ 2.4
- A valid **SSH private key** (passed as `ssh_private_key_file`).

## Build Instructions

1. Compile packer file:

   ```
   packer init .
   ```
2. Build packer file:
   ```
    packer build -var "ssh_private_key_file=~ ssh/id_ed25519" .
    ```


## Using with Vagrant

### 1. Add the box to Vagrant:
```bash
vagrant box add ubuntu-vagrant ubuntu-vagrant.box
```
### 2. Initialize a new project:
```bash
vagrant init ubuntu-vagrant
```

### 3. Up a new project
```bash
vagrant up
```