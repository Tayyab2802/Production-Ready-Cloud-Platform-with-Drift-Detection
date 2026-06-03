output "vpc_id" {
  description = "ID of the dev VPC"
  value       = module.networking.vpc_id
}
output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}


output "alb_security_group_id" {
  value = module.security.alb_security_group_id
}

output "app_security_group_id" {
  value = module.security.app_security_group_id
}

output "ecr_repository_name" {
  value = module.ecr.repository_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ec2_iam_role_name" {
  value = module.compute.ec2_iam_role_name
}

output "ec2_instance_profile_name" {
  value = module.compute.ec2_instance_profile_name
}

output "launch_template_id" {
  value = module.compute.launch_template_id
}

output "autoscaling_group_name" {
  value = module.compute.autoscaling_group_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "frontend_bucket_regional_domain_name" {
  value = aws_s3_bucket.frontend.bucket_regional_domain_name
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_waf_arn" {
  value = module.waf.web_acl_arn
}


output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_port" {
  value = module.rds.db_port
}

output "rds_database_name" {
  value = module.rds.db_name
}