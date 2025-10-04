variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_key_name" {
  description = "Name of key"
  type        = string
  default     = "Main-terraform-key_EU"
}
