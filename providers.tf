provider "aws" {
  profile = var.aws_profile_account_1
  region  = var.aws_region_account_1
}
provider "aws" {
  alias   = "account2"
  profile = var.aws_profile_account_2
  region  = var.aws_region_account_2
}
