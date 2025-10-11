
output "vpc_id" {
  value = aws_vpc.main.id
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id, 
    aws_subnet.private_2.id, 
    aws_subnet.private_3.id, 
    aws_subnet.private_4.id, 
    aws_subnet.private_5.id
  ]
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
