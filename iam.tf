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

resource "aws_iam_role" "gemini" {
  name = "gemini"
  path = "/instance/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
}
EOF
}

resource "aws_iam_policy" "access_volume" {
  description = "Allow accessing EBS volumes"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVolumes",
        "ec2:DescribeVpcs",
        "ec2:CreateVolume",
        "ec2:ModifyVolume",
        "ec2:AttachVolume",
        "ec2:DeleteVolume",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "access_ecr" {
  description = "Allow accessing ECR"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "gemini_volume" {
  role = aws_iam_role.gemini.name
  policy_arn = aws_iam_policy.access_volume.arn
}

resource "aws_iam_role_policy_attachment" "gemini_ecr" {
  role = aws_iam_role.gemini.name
  policy_arn = aws_iam_policy.access_ecr.arn
}

resource "aws_iam_instance_profile" "gemini" {
  name = "gemini"
  role = aws_iam_role.gemini.name
}
