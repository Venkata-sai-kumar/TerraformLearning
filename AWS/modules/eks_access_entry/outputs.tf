
output "access_entry_arn" {
  description = "Amazon Resource Name (ARN) of the Access Entry."
  value       = aws_eks_access_entry.main.access_entry_arn
}
