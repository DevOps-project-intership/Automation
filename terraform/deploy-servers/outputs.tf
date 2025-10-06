
output "database_private_ip" {
  value = aws_instance.database.private_ip
}

output "flask-1_private_ip" {
  value = aws_instance.flask-1.private_ip
}

output "flask-2_private_ip" {
  value = aws_instance.flask-2.private_ip
}

output "loadbalancer_private_ip" {
  value = aws_instance.loadbalancer.private_ip
}

output "consul_private_ip" {
  value = aws_instance.consul.private_ip
}