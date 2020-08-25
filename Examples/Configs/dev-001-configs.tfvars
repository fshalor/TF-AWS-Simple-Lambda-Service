# Locals for VPC's and Subnets. 
# Normally, these would be imported form other scops.
#
#


service_name          = "ms-test"
env		      = "dev-01"
aws_region            = "us-west-2"

vpc_id                = "vpc-0"
alb_acm_certificate   = "arn:aws:acm:us-west-2:445:certificate/133d"

alb_subnets = [
  "subnet-s4",
  "subnet-7d",
  "subnet-20",
]
lambda_subnets = [
  "subnet-cb",
  "subnet-ea",
  "subnet-a9",
]
database_subnets = [
  "subnet-50",
  "subnet-4f",
  "subnet-42",
]

aurora_replica_count  = 1
aurora_instance_type  = "db.t3.medium"

allowed_cidr_blocks   = ["0.0.0.0/0"] 

# Look this up! This has to match the AWS account for the region.
elb_account_id = "797873946194"  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
account_id = ""
