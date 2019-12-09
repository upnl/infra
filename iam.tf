#
# 루트계정 관련 설정
#
resource "aws_iam_account_alias" "alias" {
  account_alias = "upnl"
}

#
# 유피넬 회원들 계정 정보
#
locals {
  sysadmins = {
    integraldx = {
      name       = "넬장"
      keybase_id = "integraldx"
    }

    simnalamburt = {
      name       = "김지현"
      keybase_id = "simnalamburt"
    }

    tirr = {
      name       = "최원우"
      keybase_id = "vbchunguk"
    }

    pbzweihander = {
      name       = "이강욱"
      keybase_id = "pbzweihander"
    }
  }
}

resource "aws_iam_group" "sysadmins" {
  name = "sysadmins"
  path = "/sysadmins/"
}

resource "aws_iam_group_policy_attachment" "sysadmins" {
  group      = aws_iam_group.sysadmins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "sysadmins" {
  for_each = local.sysadmins

  name = each.key
  path = "/sysadmins/"

  tags = {
    Name = each.value.name
  }
}

resource "aws_iam_user_login_profile" "sysadmins" {
  for_each = local.sysadmins

  user    = each.key
  pgp_key = "keybase:${each.value.keybase_id}"
}

resource "aws_iam_user_group_membership" "sysadmins" {
  for_each = local.sysadmins

  user   = each.key
  groups = [aws_iam_group.sysadmins.name]
}

resource "aws_iam_access_key" "sysadmins" {
  for_each = local.sysadmins

  user    = each.key
  pgp_key = "keybase:${each.value.keybase_id}"
}

locals {
  iam_secrets = {
    for key in aws_iam_access_key.sysadmins :
    key.user => {
      aws_access_key_id               = key.id,
      encrypted_aws_secret_access_key = key.encrypted_secret
      encrypted_initial_password      = aws_iam_user_login_profile.sysadmins[key.user].encrypted_password
    }
  }
}

resource "aws_iam_account_password_policy" "sane_default" {
  minimum_password_length        = 16
  allow_users_to_change_password = true
}

#
# IAM Role and Instance Profile for "gemini"
#
resource "aws_iam_role" "gemini" {
  name = "gemini"
  path = "/instance/"

  assume_role_policy = data.aws_iam_policy_document.gemini_assume_role.json
}

data "aws_iam_policy_document" "gemini_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "gemini" {
  name = "gemini"
  role = aws_iam_role.gemini.name
}

#
# IAM Policy for AWS Cloud Controller Manager
#
resource "aws_iam_policy" "kubernetes_master" {
  description = "쿠버네티스 마스터에 필요한 권한들"
  policy      = data.aws_iam_policy_document.kubernetes_master.json
}

data "aws_iam_policy_document" "kubernetes_master" {
  statement {
    actions = [
      # https://github.com/kubernetes/cloud-provider-aws/blob/8a0b2ca/README.md#iam-policy
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyVolume",
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteVolume",
      "ec2:DetachVolume",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DescribeVpcs",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:AttachLoadBalancerToSubnets",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancerPolicy",
      "elasticloadbalancing:CreateLoadBalancerListeners",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancerListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DetachLoadBalancerFromSubnets",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
      "iam:CreateServiceLinkedRole",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "kubernetes_master" {
  role       = aws_iam_role.gemini.name
  policy_arn = aws_iam_policy.kubernetes_master.arn
}

resource "aws_iam_policy" "kubernetes_node" {
  description = "쿠버네티스 노드에 필요한 권한들"
  policy      = data.aws_iam_policy_document.kubernetes_node.json
}

data "aws_iam_policy_document" "kubernetes_node" {
  statement {
    actions = [
      # https://github.com/kubernetes/cloud-provider-aws/blob/8a0b2ca/README.md#iam-policy
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "kubernetes_node" {
  role       = aws_iam_role.gemini.name
  policy_arn = aws_iam_policy.kubernetes_node.arn
}
