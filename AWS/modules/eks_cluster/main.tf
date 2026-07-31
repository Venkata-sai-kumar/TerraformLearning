resource "aws_eks_cluster" "main" {
  name = var.cluster_name

  access_config {
    authentication_mode                         = var.access_config.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.access_config.bootstrap_cluster_creator_admin_permissions
  }

  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    endpoint_private_access = var.vpc_config.endpoint_private_access
    endpoint_public_access  = var.vpc_config.endpoint_public_access
    subnet_ids              = var.vpc_config.subnet_ids
  }

  bootstrap_self_managed_addons = var.bootstrap_self_managed_addons

  compute_config {
    enabled       = var.compute_config.enabled
    node_pools    = var.compute_config.node_pools
    node_role_arn = var.compute_config.node_role_arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = var.kubernetes_network_config.elastic_load_balancing.enabled
    }
    service_ipv4_cidr = var.kubernetes_network_config.service_ipv4_cidr
    service_ipv6_cidr = var.kubernetes_network_config.service_ipv6_cidr
    ip_family         = var.kubernetes_network_config.ip_family
  }

  storage_config {
    block_storage {
      enabled = var.storage_config.block_storage.enabled
    }
  }

  upgrade_policy {
    support_type = var.upgrade_policy.support_type
  }

  tags = var.tags
}
