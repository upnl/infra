locals {
  availability_zones = {
    a = "ap-northeast-2a",
    b = "ap-northeast-2b",
    c = "ap-northeast-2c",
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    "kubernetes.io/cluster/gemini" = "shared"
  }
}

resource "aws_default_subnet" "default" {
  for_each = local.availability_zones

  availability_zone = each.value

  tags = {
    "kubernetes.io/cluster/gemini" = "shared"
  }
}
