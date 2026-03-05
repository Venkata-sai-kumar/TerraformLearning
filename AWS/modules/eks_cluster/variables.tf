variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = "example-cluster"
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role to use for the EKS cluster"
  type        = string
}

variable "bootstrap_self_managed_addons" {
  description = "Whether to install default unmanaged add-ons during cluster creation"
  type        = bool
  default     = true
}

## The authentication mode for the cluster. Valid values are CONFIG_MAP, API or API_AND_CONFIG_MAP

variable "access_config" {
  description = "EKS Cluster access configuration"
  type = object({
    authentication_mode                         = string
    bootstrap_cluster_creator_admin_permissions = bool
  })
  default = {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }
}

variable "vpc_config" {
  description = "EKS VPC configuration"
  type = object({
    subnet_ids              = list(string)
    endpoint_private_access = bool
    endpoint_public_access  = bool
  })
  default = {
    subnet_ids              = []
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

## Request to enable or disable the compute capability on your EKS Auto Mode cluster. If the compute capability is enabled, EKS Auto Mode will create and delete EC2 Managed Instances in your AWS account.
## Configuration for node pools that defines the compute resources for your EKS Auto Mode cluster. Valid options are general-purpose and system.
## The ARN of the IAM Role EKS will assign to EC2 Managed Instances in your EKS Auto Mode cluster. This value cannot be changed after the compute capability of EKS Auto Mode is enabled..

variable "compute_config" {
  description = "EKS Auto Mode compute_config. Set to null to omit."
  type = object({
    enabled       = bool
    node_pools    = optional(list(string))
    node_role_arn = optional(string)
  })
  default = null
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.34"
}

### elastic_load_balancing - (Optional) Configuration block with elastic load balancing configuration for the cluster.
### service_ipv4_cidr -  The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks. 
### Within one of the following private IP address blocks: 10.0.0.0/8, 172.16.0.0/12, or 192.168.0.0/16.
### Doesn't overlap with any CIDR block assigned to the VPC that you selected for VPC. Between /24 and /12.
### ip_family - (Optional) The IP family used to assign Kubernetes pod and service addresses. Valid values are ipv4 (default) and ipv6. 

variable "kubernetes_network_config" {
  description = "Kubernetes network configuration for the cluster"
  type = object({
    elastic_load_balancing = object({
      enabled = bool
    })
    service_ipv4_cidr = optional(string)
    service_ipv6_cidr = optional(string)
    ip_family         = optional(string, "ipv4")
  })
}

variable "storage_config" {
  description = "Storage configuration for the cluster"
  type = object({
    block_storage = object({
      enabled = bool
    })
  })
  default = {
    block_storage = {
      enabled = true
    }
  }
}

variable "upgrade_policy" {
  description = "Upgrade policy for the cluster. Valid values are EXTENDED, STANDARD"
  type = object({
    support_type = string
  })
  default = {
    support_type = "STANDARD"
  }
}

variable "tags" {
  description = "Tags to apply to the cluster"
  type        = map(string)
  default = {
    Name        = "example-cluster"
    Environment = "dev"
    Project     = "example"
  }
}
