variable "eks_cluster_name" {
  description = "The name of the EKS cluster to which the node group belongs."
  type        = string
}

variable "node_group_name" {
  description = "The unique name to identify the node group within the cluster."
  type        = string

}

variable "node_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the node group."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to associate with the node group."
  type        = list(string)
}

variable "scaling_config" {
  description = "Configuration block for scaling settings of the node group."
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
  default = {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }
}

variable "update_config" {
  description = "Configuration block for update settings of the node group."
  type = object({
    max_unavailable = number
  })
  default = {
    max_unavailable = 1
  }
}

variable "capacity_type" {
  description = "The capacity type of the node group. Valid values are 'ON_DEMAND' and 'SPOT'."
  type        = string
  default     = "ON_DEMAND"
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group. Defaults to [\"t3.medium\"]. Terraform will only perform drift detection if a configuration value is provided."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "labels" {
  description = "A map of Kubernetes labels to assign to the node group."
  type        = map(string)
  default     = {}
}

variable "taint" {
  description = "A list of Kubernetes taints to apply to the nodes in the node group. Each taint consists of a key, value, and effect. The effect can be NoSchedule, PreferNoSchedule, or NoExecute."
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the node group."
  type        = map(string)
  default     = {}
}
