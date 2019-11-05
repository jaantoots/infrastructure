resource "cloudflare_zone" "jaan_xyz" {
  zone = "jaan.xyz"
}

module "fastmail_jaan_xyz" {
  source         = "./fastmail"
  zone           = cloudflare_zone.jaan_xyz
  extra_mx_names = ["www", "cloud"]
}

resource "cloudflare_zone" "jstd_io" {
  zone = "jstd.io"
}

module "fastmail_jstd_io" {
  source = "./fastmail"
  zone   = cloudflare_zone.jstd_io
}

resource "cloudflare_zone" "jstd_eu" {
  zone = "jstd.eu"
}
