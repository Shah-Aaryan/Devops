variable "region" {
  default     = "eu-north-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "public_subnet_cidr" {
  default     = "10.0.1.0/24"
  description = "Public subnet CIDR"
}

variable "availability_zone" {
  default     = "eu-north-1a"
  description = "AZ for the public subnet"
}

variable "my_ip" {
  description = "Your local IP for SSH access – format: x.x.x.x/32"
}

variable "ami_id" {
  default     = "ami-04dd8a25f4efa9b82"
  description = "Ubuntu 22.04 LTS in eu-north-1"
}

variable "key_name" {
  default     = "devops-key"
  description = "Name of an existing EC2 key pair"
}
