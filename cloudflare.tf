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
# 제미니 (구)
#
resource "cloudflare_record" "gemini" {
  domain = local.domain
  name   = local.domain
  type   = "A"
  value  = "121.166.66.24"
}
resource "cloudflare_record" "wildcard" {
  domain = local.domain
  name   = "*.upnl.org"
  type   = "CNAME"
  value  = local.domain
}

#
# 제미니
#
resource "cloudflare_record" "gemini_sub" {
  domain = local.domain
  name   = "gemini.upnl.org"
  type   = "A"
  value  = aws_eip.gemini.public_ip
}

#
# mailgun
#
resource "cloudflare_record" "mailgun_mx_a" {
  domain   = local.domain
  name     = local.domain
  type     = "MX"
  value    = "mxa.mailgun.org"
  priority = 10
}
resource "cloudflare_record" "mailgun_mx_b" {
  domain   = local.domain
  name     = local.domain
  type     = "MX"
  value    = "mxb.mailgun.org"
  priority = 10
}
resource "cloudflare_record" "mailgun_txt" {
  domain = local.domain
  name   = local.domain
  type   = "TXT"
  value  = "v=spf1 include:mailgun.org ~all"
}

#
# keybase
#
resource "cloudflare_record" "keybase_proof" {
  domain = local.domain
  name   = local.domain
  type   = "TXT"
  value  = "keybase-site-verification=RlPMHsWcjog7nc9MyLcMTZQ9otR8W6InTdyu_8SB8Tg"
}
