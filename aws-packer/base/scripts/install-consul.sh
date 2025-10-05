#!/bin/bash

sudo yum install -y yum-utils shadow-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

sudo yum install -y consul

sudo mkdir -p /etc/consul.d /var/lib/consul
sudo chown -R consul:consul /etc/consul.d /var/lib/consul
sudo chmod 0750 /etc/consul.d
sudo chmod 0750 /var/lib/consul