resource "aws_cloudwatch_event_rule" "five_min_schedule" {
  name                = "fiveMinEnergyFeedSchedule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "trigger_feeder" {
  rule      = aws_cloudwatch_event_rule.five_min_schedule.name
  target_id = "data_feeder"
  arn       = aws_lambda_function.data_feeder.arn
}

resource "aws_lambda_permission" "allow_eventbridge_feeder" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_feeder.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.five_min_schedule.arn
}
