variable "policy_name" {
  description = "The name of the IAM policy."
  type        = string
}

variable "path" {
  description = "The path for the IAM policy."
  type        = string
  default     = "/"
}

variable "description" {
  description = "The description of the IAM policy."
  type        = string
  default     = ""
}

variable "policy_json" {
  description = "The JSON policy document."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy_json))
    error_message = "The policy_json variable must be a valid JSON string."
  }
}

variable "tags" {
  description = "A map of tags to assign to the IAM policy."
  type        = map(string)
  default = {
    Name = "example-policy"
  }
}
