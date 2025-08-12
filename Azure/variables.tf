variable "prefix" {
  description = "A prefix used for all resources in this example"
  default     = "terrformTest"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default     = "centralus"
}

variable "environment" {
  description = "The environment for which the resources are being created"
  type        = string
  default     = "Development"
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
    env  = "development"
    Team = "DevOps"
  }
}
