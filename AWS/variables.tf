variable "dev_vpn_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.5.0.0/16"
}

variable "dev_vpn_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "dev_vpn_dns_support" {
  description = "Whether to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "public_subnet_zone2a_cidr_block" {
  description = "The CIDR block for the public subnet in availability zone 2a."
  type        = string
  default     = "10.5.0.0/24"
}

variable "public_subnet_zone2b_cidr_block" {
  description = "The CIDR block for the public subnet in availability zone 2b."
  type        = string
  default     = "10.5.1.0/24"
}

variable "private_subnet_zone2a_cidr_block" {
  description = "The CIDR block for the private subnet in availability zone 2a."
  type        = string
  default     = "10.5.32.0/19"
}

variable "private_subnet_zone2b_cidr_block" {
  description = "The CIDR block for the private subnet in availability zone 2b."
  type        = string
  default     = "10.5.64.0/19"
}

variable "isolated_subnet_zone2a_cidr_block" {
  description = "The CIDR block for the isolated subnet in availability zone 2a."
  type        = string
  default     = "10.5.2.0/24"
}

variable "isolated_subnet_zone2b_cidr_block" {
  description = "The CIDR block for the isolated subnet in availability zone 2b."
  type        = string
  default     = "10.5.3.0/24"
}

variable "eks_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "EzLabsDev-eks"
}
