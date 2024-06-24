resource "aws_iam_role" "cross-account" {
  name = "cross-account"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::112233445566:root"
		}
      }
	]
}
  )

  tags = {
    tag-key = "tag-value"
  }
}
