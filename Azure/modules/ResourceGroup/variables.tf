variable "name" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
  default     = "dummy"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
  default     = "westus"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    environment = "Prod"
    Team        = "Ezine"
  }
}
