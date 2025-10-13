
provider "aws" {
  region = var.aws_region
}


resource "aws_iam_role" "ssm_role" {
  name = "consul-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect    = "Allow"

      Principal = { 
        Service = "ec2.amazonaws.com"
      }

      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "consul-ssm-profile"
  role = aws_iam_role.ssm_role.name
}


resource "aws_instance" "consul" {
  ami                    = "ami-00609db54d76c69fd"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_ids[0]
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name
  
  associate_public_ip_address = false

  tags = { 
    Name = "Consul" 
  }
}


resource "aws_route53_zone" "internal" {
  name = "internal"
  vpc {
    vpc_id = var.vpc_id
    vpc_region = var.aws_region
  }
}
resource "aws_route53_record" "consul_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "consul.internal" 
  type    = "A"
  ttl     = "300"
  records = [aws_instance.consul.private_ip]
}