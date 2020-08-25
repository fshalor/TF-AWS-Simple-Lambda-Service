# This creates an s3 bucket for all LB logs 

locals {
  log_bucket_name = "${var.env}-${var.service_name}-elb-logs"
}



resource "aws_s3_bucket" "s3_logs" {
  bucket        = "${var.env}-${var.service_name}-elb-logs"
  force_destroy = false
  acl    = "log-delivery-write"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3-logs-block-access" {
  bucket = aws_s3_bucket.s3_logs.id

  block_public_acls             = true
  block_public_policy           = true
  restrict_public_buckets       = true
  ignore_public_acls            = true
}



resource "aws_s3_bucket_policy" "s3_logs" {
  bucket = aws_s3_bucket.s3_logs.bucket


  depends_on = [
    aws_s3_bucket_policy.s3_logs,
  ]

  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "AWSConsole-AccessLogs-Policy-1588944363817",
    "Statement": [
        {
            "Sid": "AWSConsoleStmt-${local.log_bucket_name}",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.elb_account_id}:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.log_bucket_name}/*"
        },
        {
            "Sid": "AWSLogDeliveryWrite${local.log_bucket_name}",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.log_bucket_name}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck${local.log_bucket_name}",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.log_bucket_name}"
        }
    ]
}) 
}

