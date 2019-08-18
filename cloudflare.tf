resource "cloudflare_zone" "upnl" {
  zone = "upnl.org"
  plan = "free"
}
