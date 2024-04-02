terraform {
  backend "s3" {
    bucket         = "george-terraform-backend"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-s3-backend-table"
  }
}