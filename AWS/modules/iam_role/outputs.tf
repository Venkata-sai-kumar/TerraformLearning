output "arn" {
  description = "Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.main.arn
}

output "id" {
  description = "Name of the role."
  value       = aws_iam_role.main.id
}

output "name" {
  description = "Name of the role."
  value       = aws_iam_role.main.name
}
