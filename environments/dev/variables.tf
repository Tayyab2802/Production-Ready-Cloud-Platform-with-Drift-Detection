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