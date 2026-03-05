data "aws_iam_group" "example" {
  group_name = "brandstori-prod-developers"
}

data "aws_caller_identity" "current" {}

module "eks_developers_iam_role" {
  source        = "./modules/iam_role"
  iam_role_name = "EKSAssumeRoleDevelopers"
  assume_role_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow principals in *this account* to call sts:AssumeRole,
      # but we'll restrict who via the group policy in Step 3.
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name = "EKSAssumeRoleDevelopers"
  }
}

module "eks_reader_policy" {
  source      = "./modules/iam_policy"
  policy_name = "EKSReaderPolicyDevelopers"
  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ],
        Resource = "*"
      }
    ]
  })
  tags = {
    Name = "EKSReaderPolicyDevelopers"
  }
}

module "eks_reader_role_policy_attachment" {
  source     = "./modules/iam_role_policy_attachment"
  role_name  = module.eks_developers_iam_role.name
  policy_arn = module.eks_reader_policy.arn

}

module "eks_access_developers" {
  source            = "./modules/eks_access_entry"
  cluster_name      = module.eks_cluster.name
  principal_arn     = module.eks_developers_iam_role.arn
  kubernetes_groups = ["brandstori-prod-developers"]
  tags = {
    Name = "EKSAccessEntryDevelopers"
  }
}

module "iam_policy_to_allow_assume_developers_role" {
  source      = "./modules/iam_policy"
  policy_name = "AllowAssumeEKSDevelopersRole"
  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowAssumeRole",
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "${module.eks_developers_iam_role.arn}"
      }
    ]
    }
  )
  tags = {
    Name = "AllowAssumeEKSDevelopersRole"
  }
}

module "iam_group_policy_attachment_assume_eks_developers" {
  source     = "./modules/iam_group_policy_attachment"
  group_name = data.aws_iam_group.example.group_name
  policy_arn = module.iam_policy_to_allow_assume_developers_role.arn
}
