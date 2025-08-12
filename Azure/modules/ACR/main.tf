provider "azurerm" {
  features {

  }
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.name}ContainerRegistryLab"
  resource_group_name = var.resourceGroupName
  location            = var.location
  sku                 = "Standard"
  identity { type = "SystemAssigned" }
}
