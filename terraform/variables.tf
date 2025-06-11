variable "region" {
  default = "us-east-2"
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store energy data"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources in"
}
