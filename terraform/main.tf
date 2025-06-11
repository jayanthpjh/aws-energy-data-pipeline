provider "aws" {
  region = var.region
}

resource "random_pet" "suffix" {}
