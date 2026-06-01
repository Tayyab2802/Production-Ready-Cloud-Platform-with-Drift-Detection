terraform {
  backend "s3" {
    bucket       = "production-cloud-platform-bootstrap-terraform-state"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}