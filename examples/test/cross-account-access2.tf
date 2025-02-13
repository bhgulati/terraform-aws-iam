resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "12-12-2007"
        Principal = {
          AWS = "*"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
