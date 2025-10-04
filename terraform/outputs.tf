output "jenkins_public_ip" {
  value = module.jenkins.public_ip
}

output "consul_public_ip" {
  value = module.consul.public_ip
}

output "flask_public_ip" {
  value = module.flask.public_ip
}

output "db_public_ip" {
  value = module.db.public_ip
}

output "lb_public_ip" {
  value = module.lb.public_ip
}
