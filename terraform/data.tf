data "archive_file" "generate_data_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../data_generator"
  output_path = "${path.module}/../data_generator.zip"
}

data "archive_file" "process_data_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../process_lambda"
  output_path = "${path.module}/../process_lambda.zip"
}
