
output "arn" {
  description = "Amazon Resource Name (ARN) of the EKS add-on."
  value       = aws_eks_addon.main.arn
}

output "id" {
  description = "EKS Cluster name and EKS Addon name separated by a colon (:)."
  value       = aws_eks_addon.main.id
}
