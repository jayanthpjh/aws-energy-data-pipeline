resource "aws_lambda_function" "data_feeder" {
  filename         = data.archive_file.generate_data_zip.output_path
  source_code_hash = data.archive_file.generate_data_zip.output_base64sha256
  function_name    = "data_feeder"
  handler          = "generate_data.lambda_handler"
  runtime          = "python3.10"
  role             = aws_iam_role.lambda_exec_data_feeder.arn
  environment {
    variables = {
      ENERGY_BUCKET_NAME = aws_s3_bucket.energy_data.bucket
    }
  }
}

resource "aws_lambda_function" "processor" {
  filename         = data.archive_file.process_data_zip.output_path
  source_code_hash = data.archive_file.process_data_zip.output_base64sha256
  function_name    = "data_processor"
  handler          = "process_data.lambda_handler"
  runtime          = "python3.10"
  role             = aws_iam_role.lambda_exec_processor.arn
  environment {
    variables = {
      ENERGY_BUCKET_NAME = aws_s3_bucket.energy_data.bucket
      ENERGY_TABLE_NAME  = aws_dynamodb_table.energy_table.name
    }
  }
}
