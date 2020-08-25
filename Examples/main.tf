# Main file. Probably cloned everywhere
# And then specify the key

provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "dsb"
  version = "~> 2.64.0"
}

