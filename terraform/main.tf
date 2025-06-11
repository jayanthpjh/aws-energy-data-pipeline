provider "aws" {
  region = var.region
}

resource "random_pet" "suffix" {}

data "aws_caller_identity" "current" {}
