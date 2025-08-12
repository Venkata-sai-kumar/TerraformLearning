variable "resourceGroupName" {
  description = "The name of the resource group for deployment of k8s cluster"
  default     = "Flipbook"
}

variable "name" {
  description = "name of the azure container registery"
  default     = "flipbook"
}

variable "location" {
  description = "Region location of the azure container registery"
  default     = "northcentralus"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    environment = "Prod"
    Team        = "Ezine"
  }
}
