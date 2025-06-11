resource "aws_lambda_function" "data_feeder" {
  function_name = "generate_data"
  role          = aws_iam_role.lambda_exec.arn
  filename      = data.archive_file.generate_data_zip.output_path
  source_code_hash = data.archive_file.generate_data_zip.output_base64sha256
  handler       = "generate_data.lambda_handler"
  runtime       = "python3.10"
  timeout       = 30

  environment {
    variables = {
      ENERGY_BUCKET_NAME = aws_s3_bucket.energy_data.bucket
      DYNAMODB_TABLE     = aws_dynamodb_table.energy_data_info.name
    }
  }
}

