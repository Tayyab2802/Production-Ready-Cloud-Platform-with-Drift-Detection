variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "app_security_group_id" {
  type = string
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


variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}