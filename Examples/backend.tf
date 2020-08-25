# This is a backend file. Ensure this and the PREFIX is good 


terraform {
  backend "s3" {
         bucket = "<< ALWAYS PROTECT YOUR STATES >>" 
         profile = "that_thing"
  	region = "us-east-1"
        key                     = "core/environments/dev01/fulltest/terraform.tfstate"
        encrypt                 = "true"
  }
}

