data "aws_iam_policy_document" "assume" {
  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = var.assume_role_services
    }
  }
}

resource "aws_iam_role" "main" {
  name               = var.iam_role_name
  assume_role_policy = var.assume_role_policy_json
  tags               = var.tags
}
