output "id" {
  value = azurerm_kubernetes_cluster.example.id
}

output "resource_group_name" {
  value = var.resourceGroupName
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.example.name
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}

output "kube_identity_object_id" {
  value = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id
}
