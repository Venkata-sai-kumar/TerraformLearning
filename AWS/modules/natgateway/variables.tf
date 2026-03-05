variable "nat_gateway" {
  description = "NAT Gateway configuration."
  type = object({
    availability_mode = optional(string, "zonal")  # zonal | regional
    connectivity_type = optional(string, "public") # private | public

    # zonal-only inputs
    allocation_id            = optional(string)
    private_ip               = optional(string)
    subnet_id                = optional(string)
    secondary_allocation_ids = optional(list(string))

    # regional-only inputs
    vpc_id = optional(string)
    availability_zone_address = optional(list(object({
      allocation_ids    = list(string)
      availability_zone = string
    })))

    tags = optional(map(string), {
      Name = "nat-gateway"
    })
  })

  # Basic enum validation
  validation {
    condition     = contains(["zonal", "regional"], try(var.nat_gateway.availability_mode, "zonal"))
    error_message = "nat_gateway.availability_mode must be 'zonal' or 'regional'."
  }

  validation {
    condition     = contains(["public", "private"], try(var.nat_gateway.connectivity_type, "public"))
    error_message = "nat_gateway.connectivity_type must be 'public' or 'private'."
  }

  # Rule: regional -> connectivity_type must be public
  validation {
    condition = (
      try(var.nat_gateway.availability_mode, "zonal") != "regional"
      || try(var.nat_gateway.connectivity_type, "public") == "public"
    )
    error_message = "When availability_mode is 'regional', connectivity_type must be 'public'."
  }

  # Rule: zonal requires subnet_id
  validation {
    condition = (
      try(var.nat_gateway.availability_mode, "zonal") != "zonal"
      || try(var.nat_gateway.subnet_id, null) != null
    )
    error_message = "When availability_mode is 'zonal', subnet_id is required."
  }

  # Rule: regional requires vpc_id, and must NOT set subnet_id/private_ip (and other zonal-only)
  validation {
    condition = (
      try(var.nat_gateway.availability_mode, "zonal") != "regional"
      || (
        try(var.nat_gateway.vpc_id, null) != null
        && try(var.nat_gateway.subnet_id, null) == null
        && try(var.nat_gateway.private_ip, null) == null
        && try(var.nat_gateway.secondary_allocation_ids, null) == null
      )
    )
    error_message = "When availability_mode is 'regional', vpc_id is required and subnet_id/private_ip/secondary_allocation_ids must NOT be set."
  }

  # Rule: regional must NOT set allocation_id (use availability_zone_address instead)
  validation {
    condition = (
      try(var.nat_gateway.availability_mode, "zonal") != "regional"
      || try(var.nat_gateway.allocation_id, null) == null
    )
    error_message = "When availability_mode is 'regional', allocation_id must NOT be set. Use availability_zone_address blocks."
  }

  # Rule: zonal + public requires allocation_id (per your note about public+zonal requirement)
  validation {
    condition = (
      !(try(var.nat_gateway.availability_mode, "zonal") == "zonal" && try(var.nat_gateway.connectivity_type, "public") == "public")
      || try(var.nat_gateway.allocation_id, null) != null
    )
    error_message = "When availability_mode is 'zonal' and connectivity_type is 'public', allocation_id is required."
  }

  # Rule: availability_zone_address only allowed for regional
  validation {
    condition = (
      try(var.nat_gateway.availability_mode, "zonal") == "regional"
      || try(var.nat_gateway.availability_zone_address, null) == null
    )
    error_message = "availability_zone_address can only be set when availability_mode is 'regional'."
  }
}

## Examples of how to set the variable (to be included in documentation, not in code):

#### Zonal public NAT (single AZ)

# nat_gateway = {
#   availability_mode = "regional"
#   connectivity_type = "public"
#   vpc_id            = aws_vpc.main.id

#   # optional manual mode (otherwise omit for auto mode)
#   availability_zone_address = [
#     { allocation_id = aws_eip.nat_a.id, availability_zone = "us-east-1a" },
#     { allocation_id = aws_eip.nat_b.id, availability_zone = "us-east-1b" },
#   ]
# }

#### Regional Public NAT (multi-AZ)

# nat_gateway = {
#   availability_mode = "regional"
#   connectivity_type = "public"
#   vpc_id            = aws_vpc.main.id

#   # optional manual mode (otherwise omit for auto mode)
#   availability_zone_address = [
#     { allocation_id = aws_eip.nat_a.id, availability_zone = "us-east-1a" },
#     { allocation_id = aws_eip.nat_b.id, availability_zone = "us-east-1b" },
#   ]
# }
