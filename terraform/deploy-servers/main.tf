
provider "aws" {
  region = "eu-north-1"
}


resource "aws_instance" "database" {
  ami                    = "ami-0befc82ff063f118b"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_ids[1]
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg_id]
  associate_public_ip_address = false

  tags = {
    Name = "Database"
  }
}

resource "aws_instance" "flask_1" {
  ami                    = "ami-0518861cac9f0c37a"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_ids[2]
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg_id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.flask_profile.name

  tags = {
    Name = "Flask Server 1"
  }
}

resource "aws_instance" "flask_2" {
  ami                    = "ami-0518861cac9f0c37a"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_ids[3]
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg_id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.flask_profile.name

  tags = {
    Name = "Flask Server 2"
  }
}

resource "aws_instance" "loadbalancer" {
  ami                    = "ami-0befc82ff063f118b"
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "Load Balancer"
  }
}



resource "aws_s3_bucket" "flask_user_data" {
  bucket_prefix = "hot-peppers-database-metadata"
  force_destroy = true

  tags = {
    Name = "Flask User Data"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "flask_encryption" {
  bucket = aws_s3_bucket.flask_user_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_iam_role" "flask_role" {
  name = "flask-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action  = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy" "flask_policy" {
  name = "flask-s3-access-policy"
  role = aws_iam_role.flask_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
      Resource = [
        aws_s3_bucket.flask_user_data.arn,
        "${aws_s3_bucket.flask_user_data.arn}/*"
      ]
    }]
  })
}


resource "aws_iam_instance_profile" "flask_profile" {
  name = "flask-instance-profile"
  role = aws_iam_role.flask_role.name
}


resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.eu-north-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_route_table_id]

  tags = {
    Name = "S3 Endpoint"
  }
}


resource "aws_s3_bucket_policy" "vpce_only" {
  bucket = aws_s3_bucket.flask_user_data.id

  policy = jsonencode({
    Version = "2012-10-17",

    Statement = [{
      Sid       = "AllowVPCEonly",
      Effect    = "Allow",
      Principal = "*",
      Action    = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],

      Resource  = [
        aws_s3_bucket.flask_user_data.arn,
        "${aws_s3_bucket.flask_user_data.arn}/*"
      ],

      Condition = {
        StringEquals = {
          "aws:sourceVpce" = aws_vpc_endpoint.s3_endpoint.id
        }
      }
    }]
  })
}
