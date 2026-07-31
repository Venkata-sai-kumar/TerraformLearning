
module "eks_cluster" {
  source                        = "./modules/eks_cluster"
  cluster_name                  = var.eks_name
  cluster_role_arn              = module.EKS_iam_role.arn
  bootstrap_self_managed_addons = false

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
    enabled       = true
    node_pools    = ["general-purpose", "system"]
    node_role_arn = module.EKS_node_iam_role.arn
  }

  kubernetes_version = "1.35"

  kubernetes_network_config = {
    elastic_load_balancing = {
      enabled = true
    }
    service_ipv4_cidr = "172.16.0.0/24"
    ip_family         = "ipv4"
  }

  storage_config = {
    block_storage = {
      enabled = true
    }
  }

  tags = {
    Name        = var.eks_name,
    Environment = "Development"
  }

  depends_on = [module.EKS_node_iam_role, module.EKS_iam_role, module.Dev_VPC, module.nat_gateway]
}

# data "aws_eks_cluster_auth" "eks_v2" {
#   name       = module.eks_cluster.name
#   depends_on = [module.eks_cluster]
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks_cluster.endpoint
#     cluster_ca_certificate = base64decode(module.eks_cluster.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.eks_v2.token
#   }
# }

# provider "kubernetes" {
#   host                   = module.eks_cluster.endpoint
#   cluster_ca_certificate = base64decode(module.eks_cluster.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks_v2.token
# }
