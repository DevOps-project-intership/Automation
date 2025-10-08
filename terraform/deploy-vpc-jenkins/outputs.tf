
output "vpc_id" {
  value = aws_vpc.main.id
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_sg.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id, 
    aws_subnet.private_2.id, 
    aws_subnet.private_3.id, 
    aws_subnet.private_4.id, 
    aws_subnet.private_5.id, 
    aws_subnet.private_6.id
  ]
}

output "public_subnet_id" {
  description = "ID of the public subnet for Jenkins"
  value       = aws_subnet.public.id
}
