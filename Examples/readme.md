# This is an example call of the module

## First, the assumptions:

1. It assumes that you have an s3 bucket for terraform .tfstates
2. It can take tfvars config file with environment variables.


## It builds the following things

0. A vpc with public and private subnets
1. s3 bucket for storage of files
2. An SNS topic (named)
2. An application load balancer, with rule to respond on names, with a healthcheck response on /check/
3. A target group listening on 443 and the only default for the ALB
4. An s3 event notification on /key, subscribed to the topic
6. An SQS queue, FIFO, with encryption enabled.
7. All necessary S3 encryption settings and bits. 
8. A lambda function, which can write to and read from the S3 bucket
9. An security group for AUrora
10. A serverless Aurora
11. Plumbing to connect RDS instance to AUrora. 
12. Secrests Manager RDS store user key.
13. Access to that key from Lambda.


