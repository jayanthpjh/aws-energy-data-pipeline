variable "region" {
  default = "us-east-2"
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store energy data"
}

