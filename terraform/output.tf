output "s3_bucket_name" {
  value       = aws_s3_bucket.energy_data.bucket
  description = "Name of the S3 bucket where energy data is stored."
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.energy_data.name
  description = "DynamoDB table storing processed energy data."
}

output "data_feeder_lambda_arn" {
  value       = aws_lambda_function.data_feeder.arn
  description = "ARN of the Lambda function that simulates/generates data."
}

output "processor_lambda_arn" {
  value       = aws_lambda_function.processor.arn
  description = "ARN of the Lambda function that processes data and stores it in DynamoDB."
}

output "cloudwatch_event_rule_name" {
  value       = aws_cloudwatch_event_rule.five_min_schedule.name
  description = "Name of the EventBridge rule that triggers the data feeder Lambda."
}

output "lambda_exec_feeder_role_arn" {
  value       = aws_iam_role.lambda_exec_data_feeder.arn
  description = "IAM Role ARN for Data Feeder Lambda Execution"
}

output "lambda_exec_processor_role_arn" {
  value       = aws_iam_role.lambda_exec_processor.arn
  description = "IAM Role ARN for Processor Lambda Execution"
}
