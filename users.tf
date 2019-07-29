locals {
  users = [
    ["integraldx", "넬장"],
    ["simnalamburt", "김지현"],
    ["tirr", "최원우"],
    ["pbzweihander", "이강욱"],
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
