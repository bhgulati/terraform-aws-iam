data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  identifiers                = compact(distinct(concat(var.provider_ids, [var.provider_id])))
  number_of_role_policy_arns = coalesce(var.number_of_role_policy_arns, length(var.role_policy_arns))
}

data "aws_iam_policy_document" "assume_role_with_saml" {
  dynamic "statement" {
    # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
    for_each = var.allow_self_assume_role ? [1] : []

    content {
      sid     = "ExplicitSelfRoleAssumption"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role${var.role_path}${var.role_name}"]
      }
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type = "Federated"

      identifiers = local.identifiers
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = [var.aws_saml_endpoint]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0

  name                 = var.role_name
  name_prefix          = var.role_name_prefix
  description          = var.role_description
  path                 = var.role_path
  max_session_duration = var.max_session_duration

  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.role_permissions_boundary_arn

  assume_role_policy = data.aws_iam_policy_document.assume_role_with_saml.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.create_role ? local.number_of_role_policy_arns : 0

  role       = join("", aws_iam_role.this.*.name)
  policy_arn = var.role_policy_arns[count.index]
}
