resource "aws_lambda_function" "processor" {
  function_name = "process_energy_data"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  timeout       = 30
  memory_size   = 128


  filename         = "../lambda/lambda_function.zip"
  source_code_hash = filebase64sha256("../lambda/lambda_function.zip")
=======
  filename         = data.archive_file.output.output_path
  source_code_hash = data.archive_file.output.output_base64sha256


  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.energy_table.name
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
