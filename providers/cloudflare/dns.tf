# Generated from the 2026-11-23 Cloudflare API export (audit cache).
# Import-by-ID first; run plan with the IaC token and reconcile before apply.

# ---- ffilt.us (b36262ee7b94037531e8f833a408a7df) ----
resource "cloudflare_record" "autoconfig_ffilt_us_cname" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "autoconfig.ffilt.us"
  type    = "CNAME"
  content = "privateemail.com"
  proxied = true
  ttl     = 1
  # source record id: afaea53b0f78e558f74dde977ed508b8
}

resource "cloudflare_record" "autodiscover_ffilt_us_cname" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "autodiscover.ffilt.us"
  type    = "CNAME"
  content = "privateemail.com"
  proxied = true
  ttl     = 1
  # source record id: 0f23cad786fe438c3026db515fb2ab38
}

resource "cloudflare_record" "blog_ffilt_us_cname" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "blog.ffilt.us"
  type    = "CNAME"
  content = "orange-glacier-0be44f40f.2.azurestaticapps.net"
  proxied = true
  ttl     = 1
  # source record id: 77700118bb504e78b42fd9f9c0410ade
}

resource "cloudflare_record" "wildcard_ffilt_us_cname" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "*.ffilt.us"
  type    = "CNAME"
  content = "8f3e5dfe-4a19-4b58-8ca7-f2924735876b.cfargotunnel.com"
  proxied = true
  ttl     = 1
  # source record id: 09ab4f10fcd62a46e937b00a5814133e
}

resource "cloudflare_record" "ffilt_us_cname" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "ffilt.us"
  type    = "CNAME"
  content = "orange-glacier-0be44f40f.2.azurestaticapps.net"
  proxied = true
  ttl     = 1
  # source record id: 0ed392f883047e8f5fcb5080c7bb87c2
}

resource "cloudflare_record" "mail_ffilt_us_cname" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "mail.ffilt.us"
  type    = "CNAME"
  content = "privateemail.com"
  proxied = true
  ttl     = 1
  # source record id: 09738bdcb33102ec82660ca5e2183fd2
}

resource "cloudflare_record" "ffilt_us_mx" {
  zone_id  = "b36262ee7b94037531e8f833a408a7df"
  name     = "ffilt.us"
  type     = "MX"
  content  = "mx1.privateemail.com"
  priority = 1
  proxied  = false
  ttl      = 1
  # source record id: 60cf4a5525296f5f702d73a076840177
}

resource "cloudflare_record" "ffilt_us_mx_1" {
  zone_id  = "b36262ee7b94037531e8f833a408a7df"
  name     = "ffilt.us"
  type     = "MX"
  content  = "mx2.privateemail.com"
  priority = 1
  proxied  = false
  ttl      = 1
  # source record id: 5b69f0472a55778fbc67551376c3ee9e
}

resource "cloudflare_record" "ffilt_us_mx_2" {
  zone_id  = "b36262ee7b94037531e8f833a408a7df"
  name     = "ffilt.us"
  type     = "MX"
  content  = "route1.mx.cloudflare.net"
  priority = 3
  proxied  = false
  ttl      = 1
  # source record id: 7bca64e5abbd9ca90880c2ce3b2e6bd6
}

resource "cloudflare_record" "autodiscover_tcp_ffilt_us_srv" {
  zone_id  = "b36262ee7b94037531e8f833a408a7df"
  name     = "_autodiscover._tcp.ffilt.us"
  type     = "SRV"
  content  = "0 443 privateemail.com"
  priority = 0
  proxied  = false
  ttl      = 1
  # source record id: cc090260d5eb7488c05f80bec162f026
}

resource "cloudflare_record" "blog_ffilt_us_txt" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "blog.ffilt.us"
  type    = "TXT"
  content = "\"_floqpemdjg6dbwu4gtkuckhbyzsg7fk\""
  proxied = false
  ttl     = 1
  # source record id: 7f82008183069dd6b45dfbc416bd9e36
}

resource "cloudflare_record" "default_domainkey_ffilt_us_txt" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "default._domainkey.ffilt.us"
  type    = "TXT"
  content = "\"v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArxxnFz5a+jWF/Reeamw7VHZy+oIsYaufFaLobaxxsTD4YFnW0Hgs7BwufNaD0dUGMSkI3KT7zIYiHJx4lq689H+jD3NPWWo66DaKJ/muUjNuKacC/E5pQHP3Hj/TXcDkuiDPqYUiydqxdGsRHi0Xh8icHe/8+A6oB8PeWwTfTuuQTRiwv+40Tpk8DZ7JFiRq1iX\" \"/uy8gY4fBDqr7gbuigPryxCALd6nS7zKaV1ZB/+Kee0l0SVn135ggyR2t6UmwXMM8Ufi/MI+rlqeWpd8hO36JIjmHUIhsonBLgXNaOXvgk3H1M8JC8NbzhsdSplIENv39HCwF0yu52Q+rvM6OHwIDAQAB\""
  proxied = false
  ttl     = 1
  # source record id: b4d66ad20632e3f99cb586ca3d74b28e
}

resource "cloudflare_record" "dmarc_ffilt_us_txt" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "_dmarc.ffilt.us"
  type    = "TXT"
  content = "\"v=DMARC1; p=none; rua=mailto:a1ff64a67ab5432192126c817daf57aa@dmarc-reports.cloudflare.net\""
  proxied = false
  ttl     = 1
  # source record id: 49182e432e6cf7d85c9c4a669c3d587f
}

resource "cloudflare_record" "ffilt_us_txt" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "ffilt.us"
  type    = "TXT"
  content = "_rmj8m20m4jiov7890uzrfkbija86158"
  proxied = false
  ttl     = 1
  # source record id: 8be4bf98ac7a67b6180a7f405e54a330
}

resource "cloudflare_record" "ffilt_us_txt_1" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "ffilt.us"
  type    = "TXT"
  content = "v=spf1 include:spf.privateemail.com ~all"
  proxied = false
  ttl     = 1
  # source record id: 0dc7d977e8528efe5dd3d10b873c7ebb
}

resource "cloudflare_record" "ffilt_us_txt_2" {
  zone_id = "b36262ee7b94037531e8f833a408a7df"
  name    = "ffilt.us"
  type    = "TXT"
  content = "\"j0rhybb5b8wb5ktzm1zpmdmz9m95k4lg\""
  proxied = false
  ttl     = 1
  # source record id: bed2fd97a277ca6ef0d706a21248951e
}

# ---- arewefucked.xyz (2d40df21712448ee9a3e82c4e5d1943c) ----
resource "cloudflare_record" "arewefucked_xyz_cname" {
  zone_id = "2d40df21712448ee9a3e82c4e5d1943c"
  name    = "arewefucked.xyz"
  type    = "CNAME"
  content = "white-cliff-09a42e610.3.azurestaticapps.net"
  proxied = true
  ttl     = 1
  # source record id: 55fdbc7c73e9517bbf641a736dd82565
}

resource "cloudflare_record" "arewefucked_xyz_mx" {
  zone_id  = "2d40df21712448ee9a3e82c4e5d1943c"
  name     = "arewefucked.xyz"
  type     = "MX"
  content  = "eforward5.registrar-servers.com"
  priority = 20
  proxied  = false
  ttl      = 1
  # source record id: 6d466780477e99859ad935daedab320d
}

resource "cloudflare_record" "arewefucked_xyz_mx_1" {
  zone_id  = "2d40df21712448ee9a3e82c4e5d1943c"
  name     = "arewefucked.xyz"
  type     = "MX"
  content  = "eforward4.registrar-servers.com"
  priority = 15
  proxied  = false
  ttl      = 1
  # source record id: efccd261059bc9b6a27c549f7fa0cefc
}

resource "cloudflare_record" "arewefucked_xyz_mx_2" {
  zone_id  = "2d40df21712448ee9a3e82c4e5d1943c"
  name     = "arewefucked.xyz"
  type     = "MX"
  content  = "eforward3.registrar-servers.com"
  priority = 10
  proxied  = false
  ttl      = 1
  # source record id: b428070879a344a37ec2d08107de7bf4
}

resource "cloudflare_record" "arewefucked_xyz_mx_3" {
  zone_id  = "2d40df21712448ee9a3e82c4e5d1943c"
  name     = "arewefucked.xyz"
  type     = "MX"
  content  = "eforward2.registrar-servers.com"
  priority = 10
  proxied  = false
  ttl      = 1
  # source record id: fea2ddc05893418393d7fa971d2fccd8
}

resource "cloudflare_record" "arewefucked_xyz_mx_4" {
  zone_id  = "2d40df21712448ee9a3e82c4e5d1943c"
  name     = "arewefucked.xyz"
  type     = "MX"
  content  = "eforward1.registrar-servers.com"
  priority = 10
  proxied  = false
  ttl      = 1
  # source record id: bc36615ce870c83f6b3c70fe1941a303
}

resource "cloudflare_record" "arewefucked_xyz_txt" {
  zone_id = "2d40df21712448ee9a3e82c4e5d1943c"
  name    = "arewefucked.xyz"
  type    = "TXT"
  content = "\"v=spf1 include:spf.efwd.registrar-servers.com ~all\""
  proxied = false
  ttl     = 1
  # source record id: 732bafc7b5cea0d8c35af948044f4672
}
