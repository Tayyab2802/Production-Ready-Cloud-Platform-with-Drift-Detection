variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_branch" {
  type = string
}

variable "github_allowed_subjects" {
  description = "GitHub OIDC subject claims allowed to assume this role"
  type        = list(string)
}