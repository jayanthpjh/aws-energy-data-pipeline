resource "aws_dynamodb_table" "energy_data" {
  name         = "Energy_Data_Info-${random_pet.suffix.id}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "site_id"
  range_key    = "timestamp"

  attribute {
    name = "site_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}

output "ENERGY_TABLE_NAME" {
  value = aws_dynamodb_table.energy_data.id
}
