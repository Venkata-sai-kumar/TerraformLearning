output "arn" {
  description = "ARN of the cluster"
  value       = aws_eks_cluster.main.arn
}

output "name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "certificate_authority" {
  description = "Attribute block containing certificate-authority-data for your cluster. Detailed below."
  value       = aws_eks_cluster.main.certificate_authority
}

output "certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with your cluster."
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "endpoint" {
  description = "Endpoint for your Kubernetes API server."
  value       = aws_eks_cluster.main.endpoint
}

output "id" {
  description = "Name of the cluster."
  value       = aws_eks_cluster.main.id
}

output "oidc_issue" {
  description = "Issuer URL for the OpenID Connect identity provider."
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}
