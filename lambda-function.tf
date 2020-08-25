# Simple Lambda Deploy from Module: 


# Security group. 
resource "aws_security_group" "service-lambda-sg" {
    name        = "lambda-${var.env}-${var.service_name}-sg"
    description = "Security group for ${var.env}-${var.service_name} lambda"
    vpc_id      = var.vpc_id 

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = var.allowed_cidr_blocks
    }


  # Postresql 5432


    egress {
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        "Name" = "lambda-${var.env}-${var.service_name}-sg"
      Application     = var.service_name
      Environment = var.env
      Terraform   = "True"
      CreatedBy   = "Terraform"
    }
}


module "service-lambda" {
  #source  = "../terraform-aws-lambda/"
  source = "git::https://github.com/terraform-module/terraform-aws-lambda.git?ref=tags/v2.12.4"
  #version = "2.10.0"

  function_name      = "${var.env}-${var.service_name}"
  filename            = "${path.module}/java8-lambda.zip"
  description        = "${var.env}-${var.service_name} "
  handler            = "com.function.APIGatewayProxyRequestHandler" 
  runtime            = "java8"
  memory_size        = "1024"
  concurrency        = "-1"  # Unlimited!
  lambda_timeout     = "60"  # THIS should match or mesh with ALB timeouts
  log_retention      = "3"
  role_arn           = aws_iam_role.service-lambda-role.arn
  tracing_config      = { mode = "Active" }

  vpc_config = {
    subnet_ids         = var.lambda_subnets 
    security_group_ids = [ aws_security_group.service-lambda-sg.id ] 
  }

  environment = {
    Environment = var.env
    DB_ENVIRONMENTS = "ORKEYS"
    EXAMPLE = "Can be anything and SAM can do the rest"
  }

  tags = {
    Application     = var.service_name
    Environment = var.env
    Terraform   = "True"
    CreatedBy   = "Terraform"
  }
}



# And the attachments:
resource "aws_lambda_permission" "lambda_to_lb" {
  statement_id  = "AllowExecutionFromlb232451234"
  action        = "lambda:InvokeFunction"
  function_name = module.service-lambda.name 
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = module.alb-service-app.target_group_arns[0] 
}


resource "aws_lb_target_group_attachment" "service_link" {
  target_group_arn = module.alb-service-app.target_group_arns[0] 
  target_id        = module.service-lambda.arn 
  depends_on       = [aws_lambda_permission.lambda_to_lb]
}

output "lambda-service-arn" {
  description = "Lambda ARN"
  value       = module.service-lambda.arn
}

output "lambda-service-version" {
  description = "Lambda Version"
  value       = module.service-lambda.version
}

output "lambda-service-name" {
  description = "Lambda Name"
  value       = module.service-lambda.name
}

output "lambda-service-invoke_arn" {
  description = "ARN to invoke the lambda method"
  value       = module.service-lambda.invoke_arn
}

output "lambda-service-cloudwatch_logs_arn" {
  description = "The arn of theh log group."
  value       = module.service-lambda.cloudwatch_logs_arn
}

output "lambda-service-cloudwatch_logs_name" {
  description = "The name of the log group."
  value       = module.service-lambda.cloudwatch_logs_name
}
