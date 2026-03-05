variable "instance_id" {
  description = "EC2 instance ID to associate Eip"
  type        = string
  default     = ""
}

variable "domain" {
  description = "The network in which to allocate the EIP. Default is vpc"
  type        = string
  default     = "vpc"
}

variable "network_interface_id" {
  description = "The network interface to associate with the EIP. Only one of instance_id or network_interface_id can be specified."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to be applied to the resource"
  type        = map(string)
  default = {
    Name = "ElasticIP"
  }
}
