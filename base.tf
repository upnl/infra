terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.22.0, <4"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 2.14.0, <3"
    }
  }
  required_version = ">= 0.14.2, <0.15"

  backend "remote" {
    organization = "upnl"

    workspaces {
      name = "infra"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
}

provider "cloudflare" {
  account_id = "5438816c5f1953ae97aa91863ba3d596"
}
