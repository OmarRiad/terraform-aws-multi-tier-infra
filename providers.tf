provider "aws" {
  profile = "terraform"
}

terraform {
  backend "s3" {
    bucket         = "terraform-lab-3-bucket"
    key            = "terraform/state/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
