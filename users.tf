locals {
  sysadmins = [
    # AWS IAM username, 이름, keybase ID
    ["integraldx", "넬장", "integraldx"],
    ["simnalamburt", "김지현", "simnalamburt"],
    ["tirr", "최원우", "vbchunguk"],
    ["pbzweihander", "이강욱", "pbzweihander"],
  ]
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
  count = length(local.sysadmins)

  name = local.sysadmins[count.index][0]
  path = "/sysadmins/"

  tags = {
    Name = local.sysadmins[count.index][1]
  }
}

resource "aws_iam_user_group_membership" "sysadmins" {
  count = length(local.sysadmins)

  user   = aws_iam_user.sysadmins[count.index].name
  groups = [aws_iam_group.sysadmins.name]
}

resource "aws_iam_access_key" "sysadmins" {
  count = length(local.sysadmins)

  user    = aws_iam_user.sysadmins[count.index].name
  pgp_key = "keybase:${local.sysadmins[count.index][2]}"
}

locals {
  encrypted_access_key = {
    for key in aws_iam_access_key.sysadmins :
    key.user => {
      id               = key.id,
      encrypted_secret = key.encrypted_secret
    }
  }
}

resource "aws_iam_account_password_policy" "sane_default" {
  minimum_password_length        = 16
  allow_users_to_change_password = true
}
