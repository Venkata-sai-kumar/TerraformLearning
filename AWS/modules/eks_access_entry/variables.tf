variable "cluster_name" {
  description = "The name of the EKS cluster to which the access entry will be added."
  type        = string
}

variable "principal_arn" {
  description = "The ARN of the principal (IAM user or role) to be granted access to the EKS cluster."
  type        = string
}

variable "kubernetes_groups" {
  description = "A list of Kubernetes groups that the principal will be added to."
  type        = list(string)
  default     = []
}

variable "type" {
  description = "The type of access entry. Valid values are 'STANDARD' and 'AWS_AUTH'."
  type        = string
  default     = "STANDARD"
}

variable "user_name" {
  description = "The name of the user to be associated with the access entry (optional)."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the access entry (optional)."
  type        = map(string)
  default = {
    Name = "eks-access-entry"
  }
}
