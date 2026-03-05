variable "vpc_id" {
  description = "The ID of the VPC where the subnet will be created."
  type        = string
  default     = ""
}

variable "routes" {
  description = "List of routes to add to the route table. Each route must set exactly 1 destination and exactly 1 target."
  type = list(object({
    # Destination (exactly one)
    cidr_block                 = optional(string)
    ipv6_cidr_block            = optional(string)
    destination_prefix_list_id = optional(string)

    # Target (exactly one)
    carrier_gateway_id        = optional(string)
    core_network_arn          = optional(string)
    egress_only_gateway_id    = optional(string)
    gateway_id                = optional(string)
    local_gateway_id          = optional(string)
    nat_gateway_id            = optional(string)
    network_interface_id      = optional(string)
    transit_gateway_id        = optional(string)
    vpc_endpoint_id           = optional(string)
    vpc_peering_connection_id = optional(string)
  }))
  default = []

  # Optional but strongly recommended: validate one-of constraints early
  validation {
    condition = alltrue([
      for r in var.routes : (
        length(compact([
          try(r.cidr_block, null),
          try(r.ipv6_cidr_block, null),
          try(r.destination_prefix_list_id, null),
        ])) == 1
        &&
        length(compact([
          try(r.carrier_gateway_id, null),
          try(r.core_network_arn, null),
          try(r.egress_only_gateway_id, null),
          try(r.gateway_id, null),
          try(r.local_gateway_id, null),
          try(r.nat_gateway_id, null),
          try(r.network_interface_id, null),
          try(r.transit_gateway_id, null),
          try(r.vpc_endpoint_id, null),
          try(r.vpc_peering_connection_id, null),
        ])) == 1
      )
    ])
    error_message = "Each route must supply exactly one destination (cidr_block|ipv6_cidr_block|destination_prefix_list_id) and exactly one target (gateway_id|nat_gateway_id|transit_gateway_id|...)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default = {
    Name = "main-route-table"
  }
}
