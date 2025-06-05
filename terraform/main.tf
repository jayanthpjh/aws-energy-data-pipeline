provider "aws" {
  region = var.region
}

module "s3" {
  source = "./s3"
}

module "dynamodb" {
  source = "./dynamodb"
}

module "lambda" {
  source = "./lambda"
}

module "iam" {
  source = "./iam"
}
