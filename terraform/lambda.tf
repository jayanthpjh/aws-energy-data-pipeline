resource "aws_lambda_function" "processor" {
  function_name = "process-data-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  timeout       = 30
  memory_size   = 128

  filename         = data.archive_file.process_data_zip.output_path
  source_code_hash = data.archive_file.process_data_zip.output_base64sha256
  
  environment {
    variables = {
      ENERGY_BUCKET_NAME = aws_s3_bucket.energy_data.bucket
      DYNAMODB_TABLE     = aws_dynamodb_table.energy_data_info.name
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.energy_data.arn
}
