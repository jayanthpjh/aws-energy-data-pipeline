variable "region" {
  default = "us-east-1"
}

variable "s3_bucket" {
  default = "energy-data-bucket"
}

variable "dynamodb_table" {
  default = "EnergyData"
}
