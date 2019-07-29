provider "aws" {
  version = "~> 2.21"
  region  = "ap-northeast-2"
}

terraform {
  backend "remote" {
    organization = "upnl"

    workspaces {
      name = "infra"
    }
  }
}
