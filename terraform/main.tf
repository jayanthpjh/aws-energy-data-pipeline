resource "random_pet" "suffix" {
  length = 2
}


provider "aws" {
  region = var.region
}
