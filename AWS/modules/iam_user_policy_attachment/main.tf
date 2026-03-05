resource "aws_iam_user_policy_attachment" "main" {
  user       = var.user_name
  policy_arn = var.policy_arn
}
