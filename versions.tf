terraform {
  required_version = ">= 1.1.8"

  required_providers {
    aws = {
      version = "~> 4.17.1"
    }
    template = {
      version = ">= 2.2"
    }
  }
}
