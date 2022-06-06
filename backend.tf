terraform {
  backend "s3" {
    profile        = "your-account-profile"
    encrypt        = true
    bucket         = "test-tfstates"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    key            = "test/javier-bertoli/terraform.tfstate"
  }
}
