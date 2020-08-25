

locals {
  db_name = "${var.env}-${var.service_name}" 

}


module "db" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-rds-aurora.git?ref=tags/v2.22.0"

  name                            = local.db_name

  engine                          = "aurora-postgresql"
  engine_version                  = "11.6"      	# No CW Logs before 9.6.17

  vpc_id                          = var.vpc_id
  subnets                         = var.database_subnets 

  replica_count                   = var.aurora_replica_count
  allowed_security_groups         = [ aws_security_group.service-lambda-sg.id]

  #allowed_security_groups_count   = 1
  instance_type                   = var.aurora_instance_type 
  storage_encrypted               = true
  apply_immediately               = true 
  monitoring_interval             = 10


  enabled_cloudwatch_logs_exports = ["postgresql"] 

  tags = {
    Application     = var.service_name
    Environment = var.env
    Terraform   = "True"
    CreatedBy   = "Terraform"
  }

}
