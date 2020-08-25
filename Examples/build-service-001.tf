# Terraform module call


module "sample_microservice_data" {
  source 		= "../modules/TF-Full-Lambda-Service/"

  service_name   	= var.service_name
  aws_region 		= var.aws_region
  env                   = var.env

  vpc_id                = var.vpc_id 
  alb_acm_certificate   = var.alb_acm_certificate
  alb_subnets           = var.alb_subnets 
  lambda_subnets        = var.lambda_subnets 
  database_subnets      = var.database_subnets 

  aurora_replica_count  = var.aurora_replica_count
  aurora_instance_type  = var.aurora_instance_type
  allowed_cidr_blocks   = var.allowed_cidr_blocks

  
  # Assuming logging will be enabled
  # Assuming cloudwatch alarms will be enabled
  # In future, add in security group rules to allow ingress to ALB

}
