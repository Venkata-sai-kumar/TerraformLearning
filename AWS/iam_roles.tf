
module "EKS_iam_role" {
  source = "./modules/iam_role"

  iam_role_name        = "EKSClusterPolicyRole"
  assume_role_services = ["eks.amazonaws.com"]
  assume_role_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AssumeRole"
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession",
        ]
        Principal = {
          Service = ["eks.amazonaws.com"]
        }
      }
    ]
  })

  tags = {
    Name        = "EKSClusterPolicyRole",
    "terraform" = "IaC",
    "EKS"       = "controlPlane"
  }
}

module "EKS_iam_role_attachment" {
  source = "./modules/iam_policy_attachment"

  name       = "EKSClusterPolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [module.EKS_iam_role.name]
}

module "EKS_node_iam_role" {
  source = "./modules/iam_role"

  iam_role_name        = "EKSNodePolicyRole"
  assume_role_services = ["ec2.amazonaws.com"]
  assume_role_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AssumeRole"
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession",
        ]
        Principal = {
          Service = ["ec2.amazonaws.com"]
        }
      }
    ]
  })
  tags = {
    Name        = "EKSNodePolicyRole",
    "terraform" = "IaC",
    "EKS"       = "nodeGroup"
  }
}

module "EKS_node_iam_role_attachment" {
  source = "./modules/iam_policy_attachment"

  name       = "EKSNodePolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles      = [module.EKS_node_iam_role.name]
}

module "EKS_CNI_iam_role_attachment" {
  source = "./modules/iam_policy_attachment"

  name       = "EKS_CNI_PolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  roles      = [module.EKS_node_iam_role.name]
}

module "EKS_EC2ContainerRegistry_iam_role_attachment" {
  source = "./modules/iam_policy_attachment"

  name       = "EKS_EC2ContainerRegistry_PolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = [module.EKS_node_iam_role.name]
}
