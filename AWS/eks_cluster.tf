
module "eks_cluster" {
  source                        = "./modules/eks_cluster"
  cluster_name                  = var.eks_name
  cluster_role_arn              = module.EKS_iam_role.arn
  bootstrap_self_managed_addons = true

  access_config = {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config = {
    subnet_ids = [module.private_subnet_2a.id,
      module.private_subnet_2b.id
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  compute_config = {
    enabled = false
  }

  kubernetes_version = "1.35"

  kubernetes_network_config = {
    elastic_load_balancing = {
      enabled = false
    }
    service_ipv4_cidr = "172.16.0.0/24"
    ip_family         = "ipv4"
  }

  storage_config = {
    block_storage = {
      enabled = false
    }
  }

  tags = {
    Name        = var.eks_name,
    Environment = "Development"
  }

  depends_on = [module.EKS_node_iam_role, module.EKS_iam_role]
}

