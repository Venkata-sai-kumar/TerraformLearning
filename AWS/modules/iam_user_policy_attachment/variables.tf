
variable "user_name" {
  description = "The user the policy should be applied to"
  type        = string
}

variable "policy_arn" {
  description = "The ARN of the policy you want to apply"
  type        = string
}
