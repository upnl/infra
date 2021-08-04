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
  value   = "147.46.241.87"
}
resource "cloudflare_record" "homepage" {
  zone_id = cloudflare_zone.upnl.id
  name    = local.domain
  type    = "CNAME"
  value   = cloudflare_record.edhelbroy.hostname
}
resource "cloudflare_record" "wildcard" {
  zone_id = cloudflare_zone.upnl.id
  name    = "*"
  type    = "CNAME"
  value   = cloudflare_record.edhelbroy.hostname
}
resource "cloudflare_record" "pokemon_db" {
  zone_id = cloudflare_zone.upnl.id
  name    = "pokemon"
  type    = "CNAME"
  value   = cloudflare_record.edhelbroy.hostname
}
resource "cloudflare_record" "helix" {
  zone_id = cloudflare_zone.upnl.id
  name    = "helix"
  type    = "CNAME"
  value   = cloudflare_record.edhelbroy.hostname
}
resource "cloudflare_record" "git" {
  zone_id = cloudflare_zone.upnl.id
  name    = "git"
  type    = "CNAME"
  value   = cloudflare_record.edhelbroy.hostname
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
  value   = cloudflare_record.sodrak.hostname
}
resource "cloudflare_record" "wiki" {
  zone_id = cloudflare_zone.upnl.id
  name    = "wiki"
  type    = "CNAME"
  value   = cloudflare_record.sodrak.hostname
}

#
# 에보니
#
resource "cloudflare_record" "ebony" {
  zone_id = cloudflare_zone.upnl.id
  name    = "ebony"
  type    = "A"
  value   = aws_eip.ebony.public_ip
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
