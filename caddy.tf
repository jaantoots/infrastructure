data "ignition_directory" "data_caddy" {
  filesystem = "data"
  path       = "/caddy"
  mode       = 1023
}

data "ignition_directory" "data_http" {
  filesystem = "data"
  path       = "/http"
  mode       = 493
  uid        = 500
  gid        = 500
}

resource "cloudflare_record" "archlinux" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "archlinux"
  type    = "CNAME"
  value   = cloudflare_record.cloud.hostname
}

resource "cloudflare_record" "web" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "web"
  type    = "CNAME"
  value   = cloudflare_record.cloud.hostname
}

data "ignition_file" "caddyfile" {
  filesystem = "data"
  path       = "/caddy/Caddyfile"
  mode       = 420
  content {
    content = <<EOF
http://archlinux.jaan.xyz, https://archlinux.jaan.xyz {
    errors
    log
    browse
    root /srv/http/archlinux
}

https://web.jaan.xyz {
    errors
    log
    markdown
    root /srv/http/web
}
EOF
  }
}

data "ignition_systemd_unit" "caddy" {
  name    = "caddy.service"
  content = <<EOF
[Unit]
Description=Caddy server

[Service]
Slice=machine.slice
LimitNOFILE=8192:524288
ExecStart=/usr/bin/rkt run --insecure-options=image \
    --volume=volume-var-lib-caddy,kind=host,source=/data/caddy \
    --volume=volume-srv-http,kind=host,readOnly=true,source=/data/http \
    --port=8080-tcp:80 \
    --port=8443-tcp:443 \
    --dns=1.1.1.1 \
    docker://docker.pkg.github.com/jaantoots/infrastructure/caddy:1.0.4-1 -- -agree -email ${var.acme_email}
KillMode=mixed
Restart=always

[Install]
WantedBy=multi-user.target
EOF
}
