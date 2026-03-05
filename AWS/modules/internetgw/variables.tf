variable "vpc_id" {
  description = "The ID of the VPC where the subnet will be created."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default = {
    Name = "InternetGateway"
  }
}
