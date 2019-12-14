locals {
  ecr_repositories = [
    "pokemon-db",
    "homepage",
    "helix",
  ]
}

resource "aws_ecr_repository" "docker_images" {
  for_each = toset(local.ecr_repositories)

  name                 = each.key
  image_tag_mutability = "IMMUTABLE"
}
