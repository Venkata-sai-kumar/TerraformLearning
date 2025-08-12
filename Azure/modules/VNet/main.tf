provider "azurerm" {
  features {

  }
}

resource "azurerm_virtual_network" "example" {
  resource_group_name = var.name_rg
  location            = var.location
  name                = "${var.netname}-vnet"
  address_space       = [var.address_space]
  tags                = var.tags
}
