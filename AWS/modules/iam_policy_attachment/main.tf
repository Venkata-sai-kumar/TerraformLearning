resource "aws_iam_policy_attachment" "main" {
  name       = var.name
  policy_arn = var.policy_arn
  groups     = var.groups
  roles      = var.roles
  users      = var.users
}
