data "aws_caller_identity" "present" {}

data "aws_iam_group" "devops" {
  group_name = "brandstori-devops"
}

module "eks_devops_iam_role" {
  source        = "./modules/iam_role"
  iam_role_name = "EKSAssumeRoleDevOps"
  assume_role_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow principals in *this account* to call sts:AssumeRole,
      # but we'll restrict who via the group policy in Step 3.
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.present.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name = "EKSAssumeRoleDevOps"
  }
}

module "iam_eks_admin_role_policy" {
  source      = "./modules/iam_policy"
  policy_name = "EKSAdminPolicyDevOps"
  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "eks:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:PassedToService" : "eks.amazonaws.com"
          }
        }
      }
    ]
  })
  tags = {
    Name = "EKSAdminPolicyDevOps"
  }
}

module "devops_iam_policy_role_attachment" {
  source     = "./modules/iam_role_policy_attachment"
  role_name  = module.eks_devops_iam_role.name
  policy_arn = module.iam_eks_admin_role_policy.arn
}

module "eks_access_devops" {
  source            = "./modules/eks_access_entry"
  cluster_name      = module.eks_cluster.name
  principal_arn     = module.eks_devops_iam_role.arn
  kubernetes_groups = ["brandstori-devops"]
  tags = {
    Name = "EKSAccessEntryDevOps"
  }
  depends_on = [module.eks_cluster]
}

module "iam_policy_to_allow_assume_devops_role" {
  source      = "./modules/iam_policy"
  policy_name = "AllowAssumeEKSDevOpsRole"
  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowAssumeRole",
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "${module.eks_devops_iam_role.arn}"
      }
    ]
    }
  )
  tags = {
    Name = "AllowAssumeEKSDevOpsRole"
  }
}

module "iam_group_policy_attachment_assume_eks_devops_role" {
  source     = "./modules/iam_group_policy_attachment"
  group_name = data.aws_iam_group.devops.group_name
  policy_arn = module.iam_policy_to_allow_assume_devops_role.arn
}
