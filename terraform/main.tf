provider "aws" {
  region = var.region
}

resource "random_pet" "suffix" {}

module "s3" {
  source = "./s3"
}

module "dynamodb" {
  source = "./dynamodb"
}

module "iam" {
  source = "./iam"
}

module "lambda" {
  source = "./lambda"
}

module "schedule" {
  source = "./schedule"
}
