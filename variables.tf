variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI (Free Tier)"
  default     = "ami-0e12ffc2dd465f6e4" # ap-south-1 Amazon Linux 2
}

variable "key_name" {
  description = "Existing EC2 key pair name"
}

variable "private_key_path" {
  description = "Path to .pem file"
}