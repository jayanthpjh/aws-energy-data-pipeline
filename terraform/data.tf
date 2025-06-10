data "archive_file" "output" {
  type        = "zip"
  source_file = "../lambda/lambda_function.py"
  output_path = "../lambda/lambda_function.zip"
}

data "archive_file" "feeder_output" {
  type        = "zip"
  source_file = "../data_generator/generate_data.py"
  output_path = "../data_generator/generate_data.zip"
}
