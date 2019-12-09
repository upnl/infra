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
  version = "~> 2.25"
  region  = "ap-northeast-2"
}

provider "cloudflare" {
  version    = ">= 2.2.0, <3"
  account_id = "5438816c5f1953ae97aa91863ba3d596"
}
