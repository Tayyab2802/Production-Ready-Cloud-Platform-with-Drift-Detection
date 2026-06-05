resource "aws_ssm_parameter" "container_image" {
  name  = "/production-cloud-platform/dev/container-image"
  type  = "String"
  value = "536376965240.dkr.ecr.eu-west-2.amazonaws.com/production-cloud-platform-dev-app:dev-v2"

  lifecycle {
    ignore_changes = [value]
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}