# Create SG and ALB

resource "aws_security_group" "alb-sg" {
    name        = "${var.env}-${var.service_name}-alb"
    description = "the security group for load balancer"
	  vpc_id      = var.vpc_id

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = var.allowed_cidr_blocks 
    }


    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"]
    }


    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
    Name = "${var.env}-${var.service_name}-alb"
    Application     = var.service_name
    Environment = var.env
    Terraform   = "True"
    CreatedBy   = "Terraform"
    }

}


module "alb-service-app" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-alb.git?ref=tags/v5.8.0"

  name 			= "alb-${var.env}-${var.service_name}"
  security_groups 	= [aws_security_group.alb-sg.id]
  subnets 		= var.alb_subnets 
  internal 		= true
  enable_cross_zone_load_balancing = true
  enable_http2      = true
  vpc_id 		= var.vpc_id

 access_logs = {
    bucket = local.log_bucket_name
  }


  tags = {
    Terraform 	= "True"
    Application = var.service_name
    Environment = var.env
    Terraform   = "True"
    CreatedBy   = "Terraform"
  }
 https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.alb_acm_certificate
      target_group_index = 0
    },
  ]

target_groups = [
    {
      name          = "${var.env}-${var.service_name}-https"
      backend_protocol     = "HTTPS"
      backend_port         = 8443
      target_type          = "lambda"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/" 
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 15 
        matcher             = "200,302"
      }
}
  ]

}


output "service-alb" {
  value = module.alb-service-app.this_lb_id
}

output "service-target-group-arns" {
  value = module.alb-service-app.target_group_arns
}

output "service-target-group-arn-suffixes" {
  value = module.alb-service-app.target_group_arn_suffixes
}

output "service-dns_name" {
  value = module.alb-service-app.this_lb_dns_name
}

# I need the listener arn's to make rules

output "service-https-listener-arn" {
  description = "The ARN of the HTTPS load balancer listeners created."
  value       = module.alb-service-app.https_listener_arns
}

output "service-http-listener-arn" {
  description = "The ARN of the HTTP load balancer listeners created."
  value       = module.alb-service-app.http_tcp_listener_arns
}
