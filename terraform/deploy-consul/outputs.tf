
output "consul_private_ip" {
  value = aws_instance.consul.private_ip
}

output "consul_instance_id" {
  value = aws_instance.consul.id
}