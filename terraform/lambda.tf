data "archive_file" "process_data_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../process_lambda"
  output_path = "${path.module}/../process_lambda.zip"
}

resource "aws_lambda_function" "processor" {
  function_name = "process-data-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  timeout       = 30
  memory_size   = 128

  filename         = data.archive_file.output_path
  source_code_hash = data.archive_file.output.output_base64sha256
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.energy_data.arn
}
