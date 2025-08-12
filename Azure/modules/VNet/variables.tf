variable "name_rg" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
  default     = "SaiLabs"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  type        = string
  default     = "East US"
}

variable "netname" {
  description = "A prefix used for all resources in this example"
  type        = string
  default     = "Sai"
}

variable "address_space" {
  description = "The address space that is used the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    env  = "Prod"
    Team = "Sai"
  }
}
