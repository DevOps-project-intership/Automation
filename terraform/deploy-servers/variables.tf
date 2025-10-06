
variable "vpc_id" {
  type        = string
  description = "VPC ID where to create private EC2"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for private servers"
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID for Load Balancer"
}
