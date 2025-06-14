# Data Feeder IAM Role
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
    Statement = [
      {
        Sid    = "S3Access",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.energy_data.arn,
          "${aws_s3_bucket.energy_data.arn}/*"
        ]
      },
      {
        Sid    = "CloudWatchLogs",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "feeder_attach" {
  role       = aws_iam_role.lambda_exec_data_feeder.name
  policy_arn = aws_iam_policy.data_feeder_policy.arn
}

# Processor IAM Role
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
        Sid    = "S3Access",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.energy_data.arn,
          "${aws_s3_bucket.energy_data.arn}/*"
        ]
      },
      {
        Sid    = "DynamoDBAccess",
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ],
        Resource = "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/Energy_Data_Info-${random_pet.suffix.id}"
      },
      {
        Sid    = "CloudWatchLogs",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "processor_attach" {
  role       = aws_iam_role.lambda_exec_processor.name
  policy_arn = aws_iam_policy.processor_policy.arn
}
