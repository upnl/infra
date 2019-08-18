terraform {
  required_version = ">=0.12.6, <0.13"

  backend "remote" {
    organization = "upnl"

    workspaces {
      name = "infra"
    }
  }
}

provider "aws" {
  version = "~> 2.21"
  region  = "ap-northeast-2"
}

provider "cloudflare" {
  version = ">= 1.17.1, <2"
}
