resource "aws_iam_policy" "privilegeEscalation_policy" {
  name        = "privilegeEscalation_policy"
  path        = "/"
  description = "privilegeEscalation_policy-2"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:*",
        ]
        Effect   = "Allow"
        Resource = "aws:iam/role"
      },
    ]
  })
}
