
output "database_private_ip" {
  value = aws_instance.database.private_ip
}

output "flask_private_ip" {
  value = aws_instance.flask.private_ip
}

output "loadbalancer_private_ip" {
  value = aws_instance.loadbalancer.private_ip
}

output "consul_private_ip" {
  value = aws_instance.consul.private_ip
}

