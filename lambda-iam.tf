resource "aws_iam_role" "service-lambda-role" {
    name               = "${var.env}-${var.service_name}-lambda-role"
    path               = "/service-role/"
    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "service-lambda-policy-attachment" {
    name       = "${var.env}-${var.service_name}-lambda-policy-attachment"
    policy_arn = aws_iam_policy.service-lambda-execution-policy.arn
    groups     = []
    users      = []
    roles      = [aws_iam_role.service-lambda-role.id]
}


resource "aws_iam_policy" "service-lambda-execution-policy" {
    name        = "${var.env}-${var.service_name}-lambda-execution-policy"
    path        = "/service-role/"
    description = ""
    policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:${var.aws_region}:${var.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/lambda/${var.env}-${var.service_name}-lambda:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface",
        "xray:PutTraceSegments",
        "xray:PutTelemetryRecords"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
