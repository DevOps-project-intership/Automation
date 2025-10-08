# /etc/consul.d/consul.hcl

datacenter = "my-dc-1"

data_dir = "/opt/consul"

client_addr = "0.0.0.0"

ui_config{
  enabled = true
}

service {
  name = "load-balancer" # name of the service, must be the same on frontend VMs
  id   = "load-balancer-{id}" # must be unique, like name of vm
  port = 80
}

server = false

bind_addr = "[::]" # Listen on all IPv6
bind_addr = "0.0.0.0" # Listen on all IPv4

advertise_addr = "ip_addr" # theres have to be private ip of vm
retry_join = ["consul.service.consul"]