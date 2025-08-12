output "aks_id" {
  value = module.aks.id
}

output "aks_resource_group_name" {
  value = module.aks.resource_group_name
}

output "aks_cluster_name" {
  value = module.aks.kubernetes_cluster_name
}

# for configuring to kubectl local or az cli
output "aks_kube_config" {
  value     = module.aks.kube_config_raw
  sensitive = true
}

