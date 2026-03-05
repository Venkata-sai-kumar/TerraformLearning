resource "aws_iam_policy" "main" {
  name        = var.policy_name
  path        = var.path
  description = var.description

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.policy_json

  tags = var.tags
}
