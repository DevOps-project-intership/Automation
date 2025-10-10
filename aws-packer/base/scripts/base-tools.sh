#!/bin/bash

sudo dnf -y update

sudo dnf -y install \
  wget unzip tar gzip \
  htop lsof jq net-tools \
  vim nano iptables iptables-services