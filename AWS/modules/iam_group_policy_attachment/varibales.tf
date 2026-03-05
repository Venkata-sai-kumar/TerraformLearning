
variable "group_name" {
  description = "The group the policy should be applied to"
  type        = string
}

variable "policy_arn" {
  description = "The ARN of the policy you want to apply"
  type        = string
}
