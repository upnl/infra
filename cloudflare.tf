locals {
  domain = "upnl.org"
}

resource "cloudflare_zone" "upnl" {
  zone = local.domain
  plan = "free"
}

resource "cloudflare_record" "edhelbroy" {
  domain = local.domain
  name   = "edhelbroy.upnl.org"
  type   = "A"
  value  = "147.46.242.115"
}

resource "cloudflare_record" "sodrak" {
  domain = local.domain
  name   = "sodrak.upnl.org"
  type   = "A"
  value  = "147.46.242.158"
}

resource "cloudflare_record" "gemini" {
  domain = local.domain
  name   = "upnl.org"
  type   = "A"
  value  = "121.166.66.24"
}

# TODO: Remove
resource "cloudflare_record" "uriel" {
  domain = local.domain
  name   = "uriel.upnl.org"
  type   = "A"
  value  = "147.46.113.114"
}
