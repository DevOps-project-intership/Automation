
output "database_private_ip" {
  value = aws_instance.database.private_ip
}

output "flask_1_private_ip" {
  value = aws_instance.flask_1.private_ip
}

output "flask_2_private_ip" {
  value = aws_instance.flask_2.private_ip
}

output "loadbalancer_private_ip" {
  value = aws_instance.loadbalancer.private_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.flask_user_data.bucket
}

output "s3_vpce_id" {
  value = aws_vpc_endpoint.s3_endpoint.id
}