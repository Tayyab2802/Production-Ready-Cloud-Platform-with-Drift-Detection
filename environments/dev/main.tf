module "networking" {
  source = "../../modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  nat_gateway_count    = var.nat_gateway_count
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  app_port     = 8000
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "compute" {
  source = "../../modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  private_subnet_ids    = module.networking.private_subnet_ids
  app_security_group_id = module.security.app_security_group_id

  ec2_instance_type = var.ec2_instance_type
  asg_min_size      = var.asg_min_size
  asg_desired_size  = var.asg_desired_size
  asg_max_size      = var.asg_max_size
  ami_id            = var.ami_id

  db_host     = module.rds.db_endpoint
  db_port     = module.rds.db_port
  db_name     = module.rds.db_name
  db_username = var.db_username
  db_password = var.db_password



}

module "alb" {
  source = "../../modules/alb"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  alb_security_group_id  = module.security.alb_security_group_id
  autoscaling_group_name = module.compute.autoscaling_group_name
  app_port               = 8000
}

module "rds" {
  source = "../../modules/rds"

  project_name          = var.project_name
  environment           = var.environment
  private_subnet_ids    = module.networking.private_subnet_ids
  rds_security_group_id = module.security.rds_security_group_id

  db_name     = "bankingapp"
  db_username = var.db_username
  db_password = var.db_password
}

module "waf" {
  source = "../../modules/waf"

  providers = {
    aws = aws.use1
  }

  project_name = var.project_name
  environment  = var.environment
}

module "github_oidc" {
  source = "../../modules/github_oidc"

  project_name  = var.project_name
  environment   = var.environment
  github_org    = "Tayyab2802"
  github_repo   = "production-cloud-platform"
  github_branch = "dev"
}