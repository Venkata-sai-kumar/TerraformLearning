resource "aws_nat_gateway" "main" {
  availability_mode = try(var.nat_gateway.availability_mode, "zonal")
  connectivity_type = try(var.nat_gateway.connectivity_type, "public")

  # Zonal only (set to null when not applicable)
  subnet_id                = try(var.nat_gateway.availability_mode, "zonal") == "zonal" ? var.nat_gateway.subnet_id : null
  allocation_id            = try(var.nat_gateway.availability_mode, "zonal") == "zonal" ? try(var.nat_gateway.allocation_id, null) : null
  private_ip               = try(var.nat_gateway.availability_mode, "zonal") == "zonal" ? try(var.nat_gateway.private_ip, null) : null
  secondary_allocation_ids = try(var.nat_gateway.availability_mode, "zonal") == "zonal" ? try(var.nat_gateway.secondary_allocation_ids, null) : null

  # Regional only
  vpc_id = try(var.nat_gateway.availability_mode, "zonal") == "regional" ? var.nat_gateway.vpc_id : null

  dynamic "availability_zone_address" {
    for_each = (
      try(var.nat_gateway.availability_mode, "zonal") == "regional"
      ? { for a in try(var.nat_gateway.availability_zone_address, []) : a.availability_zone => a }
      : {}
    )

    content {
      allocation_ids    = availability_zone_address.value.allocation_ids
      availability_zone = availability_zone_address.value.availability_zone
    }
  }

  tags = var.nat_gateway.tags

  # Extra safety net: resource preconditions (nice error messages tied to this resource)
  lifecycle {
    precondition {
      condition = (
        try(var.nat_gateway.availability_mode, "zonal") != "regional"
        || try(var.nat_gateway.connectivity_type, "public") == "public"
      )
      error_message = "aws_nat_gateway.main: regional requires connectivity_type='public'."
    }

    precondition {
      condition = (
        try(var.nat_gateway.availability_mode, "zonal") != "zonal"
        || try(var.nat_gateway.subnet_id, null) != null
      )
      error_message = "aws_nat_gateway.main: zonal requires subnet_id."
    }
  }
}
