# TF-AWS-Simple-Lambda-Service  (Micro Flavor)

This module creates a very very simple Lambda service, with minimal connections to other things. 

It expects a few inputs to be created, as if this were to be deployed inside or alongside other infrastrucutre. At the least, this assumes that someone who makes infrastructure provides you with some bits and pieces: 

1. A VPC, an a Region
2. Public (alb) , Private (Lambda) and Database Subnets in N az's. These Subnets can be the same, or different. 
3. An ACM certificate. 

With this information in hand, simpley bake up a .tfvars file, and go to town with your CI!

This also assumes that you will want cloudwatch logging, (And in a future release; Alarms!) 
This also assumes that you will be selecting between fronting your lambda with an API GW, or ALB. 
And lastly, this assumes you will want alarms about your stack to go to a place. 

For kicks, in this example, the Lambda has access to an S3 bucket for storing data, and events are setup from that bucket to an SNS Topic, for fanning out to other bits of infrastructure. 

## Set your configs into tfvars
vi Configs/StuffThings.tfvars

run with: 
terraform init
terraform plan -var-file=Configs/dev-001-configs.tfvars
terraform  apply -var-file=Configs/dev-001-configs.tfvars

## Example Terraform Module Call
  

module "sample_microservice_data" {
  source                = "../modules/TF-Full-Lambda-Service/"

  service_name          = var.service_name
  aws_region            = var.aws_region
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
