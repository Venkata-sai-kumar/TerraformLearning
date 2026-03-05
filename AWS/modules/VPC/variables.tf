variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.2.0.0/16"
}

variable "dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "dns_support" {
  description = "Whether to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default = {
    Name        = "ProjectVPC"
    Environment = "dev"
  }
}
