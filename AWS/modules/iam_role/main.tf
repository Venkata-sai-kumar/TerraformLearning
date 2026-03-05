resource "aws_iam_role" "main" {
  name               = var.iam_role_name
  assume_role_policy = var.assume_role_policy_json
  tags               = var.tags
}
