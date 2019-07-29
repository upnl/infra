locals {
  sysadmins = [
    # AWS IAM username, 이름, keybase ID
    ["integraldx", "넬장", "integraldx"],
    ["simnalamburt", "김지현", "simnalamburt"],
    ["tirr", "최원우", "vbchunguk"],
    ["pbzweihander", "이강욱", "pbzweihander"],
  ]
}

resource "aws_iam_user" "sysadmins" {
  count = length(local.sysadmins)

  name = local.sysadmins[count.index][0]
  path = "/sysadmin/"

  tags = {
    Name = local.sysadmins[count.index][1]
  }
}

resource "aws_iam_access_key" "sysadmins" {
  count = length(local.sysadmins)

  user    = local.sysadmins[count.index][0]
  pgp_key = "keybase:${local.sysadmins[count.index][2]}"
}

output "encrypted_access_key_secret" {
  value = {
    for key in aws_iam_access_key.sysadmins :
    key.user => {
      id               = key.id,
      encrypted_secret = key.encrypted_secret
    }
  }
}
