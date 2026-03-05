variable "cluster_name" {
  description = "The name of the EKS cluster to which the add-on will be added."
  type        = string
}

variable "addon_name" {
  description = "The name of the add-on. Must match one of the names returned by ListAddons."
  type        = string
}

variable "addon_version" {
  description = "The version of the add-on. Must match a version returned by DescribeAddonVersions."
  type        = string
}

variable "resolve_conflicts_on_create" {
  description = "How to resolve field value conflicts when creating. Valid values: NONE, OVERWRITE."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "OVERWRITE"], var.resolve_conflicts_on_create)
    error_message = "resolve_conflicts_on_create must be one of: NONE, OVERWRITE."
  }
}

variable "resolve_conflicts_on_update" {
  description = "How to resolve field value conflicts on update. Valid values: NONE, OVERWRITE, PRESERVE."
  type        = string
  default     = "PRESERVE"

  validation {
    condition     = contains(["NONE", "OVERWRITE", "PRESERVE"], var.resolve_conflicts_on_update)
    error_message = "resolve_conflicts_on_update must be one of: NONE, OVERWRITE, PRESERVE."
  }
}

variable "configuration_values" {
  description = "Custom configuration values for the addon as a single JSON string (must match describe-addon-configuration schema)."
  type        = string

  validation {
    condition     = can(jsondecode(var.configuration_values))
    error_message = "configuration_values must be valid JSON when provided."
  }
}

## The Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service account. 
### The role must be assigned the IAM permissions required by the add-on. If you don't specify an existing IAM role, then the add-on uses the permissions assigned to the node IAM role.

variable "service_account_role_arn" {
  description = "Existing IAM role ARN to bind to the add-on's service account. If unset, node IAM role permissions are used."
  type        = string

  validation {
    condition = (
      can(regex("^arn:aws(-[a-z]+)?:iam::[0-9]{12}:role\\/.+$", var.service_account_role_arn))
    )
    error_message = "service_account_role_arn must be a valid IAM role ARN."
  }
}

variable "pod_identity_association" {
  description = "Optional EKS Pod Identity association settings for the add-on. If provided, both role_arn and service_account are required."

  type = object({
    role_arn        = string
    service_account = string
  })
}

variable "tags" {
  description = "The metadata to apply to the add-on to assist with categorization and organization."
  type        = map(string)
  default = {
    Name = "eks-addon"
  }
}
