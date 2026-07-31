output "arn" {
  description = "ARN assigned by AWS to this policy."
  value       = aws_iam_policy.main.arn
}

output "attachment_count" {
  description = "Number of entities (users, groups, and roles) that the policy is attached to."
  value       = aws_iam_policy.main.attachment_count
}

output "id" {
  description = "ARN assigned by AWS to this policy."
  value       = aws_iam_policy.main.id
}

output "policy_id" {
  description = "Policy's ID."
  value       = aws_iam_policy.main.policy_id
}
