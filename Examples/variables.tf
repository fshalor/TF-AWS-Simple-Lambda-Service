# Input variables for function

variable "service_name" {
  default     = "lamb chops"
}

variable "env" {
  default     = "qa"
  description = "The place were you isolate your scope to a thing."
}

variable "aws_region" {
    default = "us-east-1"
}

variable "vpc_id" {
  default     = ""
  description = " The VPC for stashing kit"
}

variable "alb_acm_certificate" {
  default     = ""
  description = "ACM Certificate Provided"
}

variable "alb_subnets" {
  default = []
}
variable "lambda_subnets" {
  default = []
}
variable "database_subnets" {
  default = []
}

variable "aurora_replica_count" {
  default 	= 0
  description 	= "Number of Replicas"
}
variable "aurora_instance_type" {
  default 	= "db.t3.small"
  description 	= "Aurora Instance Type"
}

variable "allowed_cidr_blocks" {
  default 	= [ "192.168.0.4/30", "192.168.0.23/28"]
  description 	= ""
}

variable "elb_account_id" {
  default 	= "797873946194"
  description 	= "ELB AWS account id used for aws lb logs. Look up by searching for load-balancer-access-logs"
}

variable "account_id" {
  default 	= "012345566"
  description 	= "AWS Account ID."
}

