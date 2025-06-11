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
      ENERGY_TABLE_NAME  = aws_dynamodb_table.energy_data.name
    }
  }
}

# Allow S3 to invoke the processor Lambda function
resource "aws_lambda_permission" "allow_s3_invoke_processor" {
  statement_id  = "AllowS3InvokeProcessor"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.energy_data.arn
}

# S3 bucket notification for the processor Lambda
resource "aws_s3_bucket_notification" "processor_trigger" {
  bucket = aws_s3_bucket.energy_data.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke_processor]
}
