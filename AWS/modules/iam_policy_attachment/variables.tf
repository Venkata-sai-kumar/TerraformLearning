### Required variables
variable "name" {
  description = "The name of the attachment."
  type        = string
  default     = null
}

variable "policy_arn" {
  description = "The ARN of the policy to attach."
  type        = string
  default     = null
}

### Optional variables
variable "users" {
  description = "The users to attach the policy to."
  type        = list(string)
  default     = []
}

variable "roles" {
  description = "The roles to attach the policy to."
  type        = list(string)
  default     = []
}

variable "groups" {
  description = "The groups to attach the policy to."
  type        = list(string)
  default     = []
}
