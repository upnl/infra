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
  zone_id = cloudflare_zone.upnl.id
  name    = "edhelbroy"
  type    = "A"
  value   = "147.46.242.115"
}

#
# 소드락
#
resource "cloudflare_record" "sodrak" {
  zone_id = cloudflare_zone.upnl.id
  name    = "sodrak"
  type    = "A"
  value   = "147.46.242.158"
}
resource "cloudflare_record" "sodrak_wildcard" {
  zone_id = cloudflare_zone.upnl.id
  name    = "*.sodrak"
  type    = "CNAME"
  value   = "sodrak.upnl.org"
}
resource "cloudflare_record" "wiki" {
  zone_id = cloudflare_zone.upnl.id
  name    = "wiki"
  type    = "CNAME"
  value   = "sodrak.upnl.org"
}

#
# 제미니 (구)
#
resource "cloudflare_record" "gemini" {
  zone_id = cloudflare_zone.upnl.id
  name    = local.domain
  type    = "A"
  value   = "121.140.51.227"
}
resource "cloudflare_record" "wildcard" {
  zone_id = cloudflare_zone.upnl.id
  name    = "*"
  type    = "CNAME"
  value   = local.domain
}

#
# 제미니
#
resource "cloudflare_record" "gemini_sub" {
  zone_id = cloudflare_zone.upnl.id
  name    = "gemini.upnl.org"
  type    = "A"
  value   = aws_eip.gemini.public_ip
}

#
# mailgun
#
resource "cloudflare_record" "mailgun_mx_a" {
  zone_id  = cloudflare_zone.upnl.id
  name     = local.domain
  type     = "MX"
  value    = "mxa.mailgun.org"
  priority = 10
}
resource "cloudflare_record" "mailgun_mx_b" {
  zone_id  = cloudflare_zone.upnl.id
  name     = local.domain
  type     = "MX"
  value    = "mxb.mailgun.org"
  priority = 10
}
resource "cloudflare_record" "mailgun_txt" {
  zone_id = cloudflare_zone.upnl.id
  name    = local.domain
  type    = "TXT"
  value   = "v=spf1 include:mailgun.org ~all"
}

#
# keybase
#
resource "cloudflare_record" "keybase_proof" {
  zone_id = cloudflare_zone.upnl.id
  name    = local.domain
  type    = "TXT"
  value   = "keybase-site-verification=RlPMHsWcjog7nc9MyLcMTZQ9otR8W6InTdyu_8SB8Tg"
}
