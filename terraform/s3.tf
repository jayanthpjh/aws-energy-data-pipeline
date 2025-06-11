resource "aws_s3_bucket" "energy_data" {
  bucket = "energy-data-${random_pet.suffix.id}"
}

output "ENERGY_BUCKET_NAME" {
  value = aws_s3_bucket.energy_data.id
}
