locals {
  users = [
    # AWS IAM username, 이름, keybase ID
    ["integraldx", "넬장", "integraldx"],
    ["simnalamburt", "김지현", "simnalamburt"],
    ["tirr", "최원우", "vbchunguk"],
    ["pbzweihander", "이강욱", "pbzweihander"],
  ]
}

resource "aws_iam_user" "users" {
  count = length(local.users)

  name = local.users[count.index][0]
  path = "/sysadmin/"

  tags = {
    Name = local.users[count.index][1]
  }
}

resource "aws_iam_access_key" "keys" {
  count = length(local.users)

  user    = local.users[count.index][0]
  pgp_key = "keybase:${local.users[count.index][2]}"
}

output "encrypted_access_key_secret" {
  value = zipmap(
    local.users[*][1],
    aws_iam_access_key.keys[*].encrypted_secret
  )
}
