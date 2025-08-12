output "vnet_id" {
  value       = azurerm_virtual_network.example.id
  description = "The ID of the Virtual Network"
}

output "vnet_name" {
  value       = azurerm_virtual_network.example.name
  description = "The name of the Virtual Network"
}
