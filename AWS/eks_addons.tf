
# module "eks_pod_identity" {
#   source        = "./modules/eks_addon"
#   addon_name    = "eks-pod-identity-agent"
#   cluster_name  = module.eks_cluster.name
#   addon_version = "v1.3.10-eksbuild.2q"

#   depends_on = [module.eks_cluster]
# }

# data "aws_eks_addon" "example" {
#   addon_name   = "eks-pod-identity-agent"
#   cluster_name = module.eks_cluster.name

#   depends_on = [module.eks_cluster]
# }

module "cluster_assume_iam_role_pods" {
  source        = "./modules/iam_role"
  iam_role_name = "EKSClusterAssumeRolePods"
  assume_role_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = "EKSClusterAssumeRolePods"
  }

  depends_on = [module.eks_cluster]
}

module "s3_iam_role_policy_attachment" {
  source     = "./modules/iam_role_policy_attachment"
  role_name  = module.cluster_assume_iam_role_pods.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

  depends_on = [module.eks_cluster]
}

# module "cluster_autoscaler_role_iam_policy" {
#   source      = "./modules/iam_policy"
#   policy_name = "EKSClusterAutoScalerRolePolicy"
#   policy_json = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "autoscaling:DescribeAutoScalingGroups",
#           "autoscaling:DescribeAutoScalingInstances",
#           "autoscaling:DescribeLaunchConfigurations",
#           "autoscaling:DescribeScalingActivities",
#           "autoscaling:DescribeTags",
#           "ec2:DescribeImages",
#           "ec2:DescribeInstanceTypes",
#           "ec2:DescribeLaunchTemplateVersions",
#           "ec2:GetInstanceTypesFromInstanceRequirements",
#           "eks:DescribeNodegroup"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "autoscaling:SetDesiredCapacity",
#           "autoscaling:TerminateInstanceInAutoScalingGroup"
#         ]
#         Resource = "*"
#       },
#     ]
#   })
#   tags = {
#     Name = "EKSClusterAutoScalerRolePolicy"
#   }
# }

# module "cluster_auoscaler_role_policy_attachment" {
#   source     = "./modules/iam_role_policy_attachment"
#   role_name  = module.cluster_assume_iam_role_pods.name
#   policy_arn = module.cluster_autoscaler_role_iam_policy.arn
# }
