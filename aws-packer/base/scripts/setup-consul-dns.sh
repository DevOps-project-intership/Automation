#!/bin/bash

sudo mkdir /etc/systemd/resolved.conf.d/

sudo mv /tmp/consul.conf /etc/systemd/resolved.conf.d/consul.conf

sudo iptables --table nat --append OUTPUT --destination localhost --protocol udp --match udp --dport 53 --jump REDIRECT --to-ports 8600
sudo iptables --table nat --append OUTPUT --destination localhost --protocol tcp --match tcp --dport 53 --jump REDIRECT --to-ports 8600

sudo service iptables save

sudo systemctl enable --now iptables
sudo systemctl restart systemd-resolved
