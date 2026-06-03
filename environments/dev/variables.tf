variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways for this environment"
  type        = number
}

variable "ec2_instance_type" {
  type = string
}

variable "asg_min_size" {
  type = number
}

variable "asg_desired_size" {
  type = number
}

variable "asg_max_size" {
  type = number
}

variable "ami_id" {
  type = string
}

variable "db_username" {
  description = "PostgreSQL database username"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
}