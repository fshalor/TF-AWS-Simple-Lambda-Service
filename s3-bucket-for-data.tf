# This is NOT for the production image page data buckets
# Goal is to make a bucket for the local testing of the app. After the app tests out, it can be converted to point to the real bucket
# Or something. Right now, just for lower envs. 

locals {

data_s3_bucket = "${var.env}-${var.service_name}"
}




resource "aws_s3_bucket" "app-data" {
  bucket        = local.data_s3_bucket
  force_destroy = false

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app-data-block-access" {
  bucket = aws_s3_bucket.app-data.id

  block_public_acls   		= true
  block_public_policy 		= true
  restrict_public_buckets 	= true
  ignore_public_acls 		= true
}


resource "aws_sns_topic" "topic-s3-app-uploader" {
  name = "${var.service_name}-${var.env}-topic"

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": {"AWS":"*"},
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:${var.service_name}-${var.env}-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.app-data.arn}"}
        }
    }]
}
POLICY
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.app-data.id
  # This is going to have a silly tf-created funky name. Nothing I can do about it. 

  topic {
    topic_arn     = aws_sns_topic.topic-s3-app-uploader.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "data/"
  }
}

