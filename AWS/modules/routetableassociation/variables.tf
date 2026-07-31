variable "subnet_id" {
  description = "Subnet ID to associate the route table"
  type        = string
  default     = ""
}

variable "route_table_id" {
  description = "Rotue table Id for association to subnet"
  type        = string
  default     = ""
}
