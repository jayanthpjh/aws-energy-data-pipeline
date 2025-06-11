resource "aws_iam_role" "lambda_exec_data_feeder" {
  name = "lambda-exec-feeder-${random_pet.suffix.id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "data_feeder_policy" {
  name = "feeder-policy-${random_pet.suffix.id}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
      Effect = "Allow",
      Resource = [
        "arn:aws:s3:::energy-data-*",
        "arn:aws:s3:::energy-data-*/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "feeder_attach" {
  role       = aws_iam_role.lambda_exec_data_feeder.name
  policy_arn = aws_iam_policy.data_feeder_policy.arn
}

# Processor Role
resource "aws_iam_role" "lambda_exec_processor" {
  name = "lambda-exec-processor-${random_pet.suffix.id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "processor_policy" {
  name = "processor-policy-${random_pet.suffix.id}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:GetObject", "s3:ListBucket"],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::energy-data-*",
          "arn:aws:s3:::energy-data-*/*"
        ]
      },
      {
        Action = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:GetItem"],
        Effect = "Allow",
        Resource = "arn:aws:dynamodb:*:*:table/Energy_Data_Info-*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "processor_attach" {
  role       = aws_iam_role.lambda_exec_processor.name
  policy_arn = aws_iam_policy.processor_policy.arn
}
