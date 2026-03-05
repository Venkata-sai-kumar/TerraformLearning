output "arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group."
  value       = aws_eks_node_group.main.arn
}

output "id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon (:)."
  value       = aws_eks_node_group.main.id
}

output "auto_scaling_group_name" {
  description = "The unique name to identify the node group within the cluster."
  value       = aws_eks_node_group.main.resources[0].autoscaling_groups[0].name
}

output "remote_access_security_group_id" {
  description = "Identifier of the remote access EC2 Security Group."
  value       = aws_eks_node_group.main.resources[0].remote_access_security_group_id
}
