module "ec2_worker_nodes" {
  source           = "./modules/worker_nodes"
  eks_cluster_name = module.eks_cluster.name
  node_group_name  = var.worker_node_group_name
  node_role_arn    = module.EKS_node_iam_role.arn
  subnet_ids       = [module.private_subnet_2b.id, module.private_subnet_2a.id]

  scaling_config = {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config = {
    max_unavailable = 1
  }
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.micro"]
  labels = {
    "environment" = "development"
  }
  taint = [
    {
      key    = "dedicated"
      value  = "worker-nodes"
      effect = "SCHEDULE"
    }
  ]
  tags = {
    Name        = var.worker_node_group_name,
    environment = "Development"
  }

  depends_on = [module.EKS_node_iam_role, module.EKS_iam_role, module.eks_cluster]
}

module "ec2_spot_nodes" {
  source           = "./modules/worker_nodes"
  eks_cluster_name = module.eks_cluster.name
  node_group_name  = var.spot_node_group_name
  node_role_arn    = module.EKS_node_iam_role.arn
  subnet_ids       = [module.private_subnet_2b.id, module.private_subnet_2a.id]

  ami_type = "AL2_x86_64"
  scaling_config = {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config = {
    max_unavailable = 1
  }
  capacity_type  = "SPOT"
  instance_types = ["t3.micro"]
  labels = {
    "environment" = "devQA"
  }
  taint = [
    {
      key    = "eks.amazonaws.com/capacityType"
      value  = "SPOT"
      effect = "NO_SCHEDULE"
    }
  ]
  tags = {
    Name        = var.spot_node_group_name,
    environment = "Development"
  }

  depends_on = [module.EKS_node_iam_role, module.EKS_iam_role, module.eks_cluster]
}
