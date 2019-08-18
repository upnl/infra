locals {
  domain = "upnl.org"
}

resource "cloudflare_zone" "upnl" {
  zone = local.domain
  plan = "free"
}

#
# 에델브로이
#
resource "cloudflare_record" "edhelbroy" {
  domain = local.domain
  name   = "edhelbroy.upnl.org"
  type   = "A"
  value  = "147.46.242.115"
}

#
# 소드락
#
resource "cloudflare_record" "sodrak" {
  domain = local.domain
  name   = "sodrak.upnl.org"
  type   = "A"
  value  = "147.46.242.158"
}
resource "cloudflare_record" "sodrak_wildcard" {
  domain = local.domain
  name   = "*.sodrak.upnl.org"
  type   = "CNAME"
  value  = "sodrak.upnl.org"
}
resource "cloudflare_record" "wiki" {
  domain = local.domain
  name   = "wiki.upnl.org"
  type   = "CNAME"
  value  = "sodrak.upnl.org"
}

#
# 제미니
#
resource "cloudflare_record" "gemini" {
  domain = local.domain
  name   = "upnl.org"
  type   = "A"
  value  = "121.166.66.24"
}
resource "cloudflare_record" "gemini_sub" {
  domain = local.domain
  name   = "gemini.upnl.org"
  type   = "CNAME"
  value  = "upnl.org"
}
resource "cloudflare_record" "wildcard" {
  domain = local.domain
  name   = "*.upnl.org"
  type   = "CNAME"
  value  = "gemini.upnl.org"
}

#
# 유리엘
# TODO: Remove
#
resource "cloudflare_record" "uriel" {
  domain = local.domain
  name   = "uriel.upnl.org"
  type   = "A"
  value  = "147.46.113.114"
}
resource "cloudflare_record" "uriel_wildcard" {
  domain = local.domain
  name   = "*.uriel.upnl.org"
  type   = "CNAME"
  value  = "uriel.upnl.org"
}
