resource "aws_iam_role" "lambda_exec" {
  name = "energy_data_lambda_exec_role-${random_string.iam_suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "energy_data_lambda_logs-${random_string.iam_suffix.result}"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
