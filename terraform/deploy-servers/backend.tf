
terraform {
  backend "s3" {
    bucket         = "hot-peppers-terraform-state-bucket"   
    key            = "servers/terraform.tfstate" 
    region         = "eu-north-1"
    encrypt        = true
  }
}