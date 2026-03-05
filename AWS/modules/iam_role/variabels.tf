variable "iam_role_name" {
  description = "The name of the IAM role."
  type        = string
  default     = ""
}

variable "assume_role_services" {
  description = "AWS service principals allowed to assume this role."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "assume_role_policy_json" {
  description = "Trust policy JSON for assume_role_policy."
  type        = string

  validation {
    condition     = can(jsondecode(var.assume_role_policy_json))
    error_message = "assume_role_policy_json must be valid JSON."
  }
}

variable "tags" {
  description = "A map of tags to assign to the IAM role."
  type        = map(string)
  default = {
    Name = "example-iam-role"
  }
}
