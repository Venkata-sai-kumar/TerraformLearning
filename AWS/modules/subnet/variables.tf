variable "cidr_block" {
  description = "The CIDR block for the subnet."
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "The availability zone for the subnet."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The ID of the VPC to which the subnet belongs."
  type        = string
  default     = ""
}

variable "public_ip_on_launch" {
  description = "Whether to assign a public IP address to instances launched in this subnet."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the subnet."
  type        = map(string)
  default = {
    Name = "Project-subnet"
  }
}
