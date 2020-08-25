resource "aws_sns_topic" "ops-notify-only" {
  name            = "ops-notify-${var.service_name}-${var.env}"
  display_name    = "Ops Generic Notify"
  policy          = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:${var.aws_region}:${var.account_id}:ops-notify-${var.service_name}-${var.env}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.account_id}"
        }
      }
    }
  ]
}
POLICY
}


