resource "random_string" "s3_suffix" {
  length  = 8
  special = false
  upper   = false
}
