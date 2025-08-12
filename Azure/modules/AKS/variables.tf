variable "resourceGroupName" {
  description = "The name of the resource group for deployment of k8s cluster"
  default     = "Flipbook"
}

variable "prefix" {
  description = "A prefix used for all resources in this example"
  default     = "Ezine"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default     = "East US"
}

variable "deploymenttype" {
  description = "Type of deployment/environment"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    env  = "Prod"
    Team = "Ezine"
  }
}
