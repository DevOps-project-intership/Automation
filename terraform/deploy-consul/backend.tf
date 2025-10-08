
terraform {
  backend "s3" {
    bucket         = "hot-peppers-terraform-state-bucket"   
    key            = "consul/terraform.tfstate" 
    region         = "eu-north-1"
    encrypt        = true
  }
}