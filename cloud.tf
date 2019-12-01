resource "digitalocean_droplet" "cloud" {
  image     = "coreos-stable"
  name      = "cloud.jaan.xyz"
  region    = "ams3"
  size      = "s-1vcpu-1gb"
  ipv6      = true
  ssh_keys  = [for key in digitalocean_ssh_key.keys : key.fingerprint]
  user_data = data.ignition_config.cloud.rendered
}

resource "digitalocean_volume" "cloud" {
  region                   = "ams3"
  name                     = "cloud"
  size                     = 10
  initial_filesystem_type  = "ext4"
  initial_filesystem_label = "data"
  description              = "${digitalocean_droplet.cloud.name} data volume"
}

resource "digitalocean_volume_attachment" "cloud" {
  droplet_id = digitalocean_droplet.cloud.id
  volume_id  = digitalocean_volume.cloud.id
}

data "ignition_config" "cloud" {
  filesystems = [
    data.ignition_filesystem.data.id,
  ]
  directories = [
    data.ignition_directory.authorized_keys.id,
    data.ignition_directory.data_pass.id,
    data.ignition_directory.data_gps.id,
    data.ignition_directory.data_taskd.id,
    data.ignition_directory.data_caddy.id,
    data.ignition_directory.data_http.id,
    data.ignition_directory.data_http_archlinux.id,
    data.ignition_directory.data_http_web.id,
  ]
  files = [
    data.ignition_file.docker_auth.id,
    data.ignition_file.sshd_config.id,
    data.ignition_file.pass_auth.id,
    data.ignition_file.gps_auth.id,
    data.ignition_file.caddyfile.id,
  ]
  systemd = [
    data.ignition_systemd_unit.data_resize.id,
    data.ignition_systemd_unit.data_mount.id,
    data.ignition_systemd_unit.pass.id,
    data.ignition_systemd_unit.taskserver.id,
    data.ignition_systemd_unit.caddy.id,
  ]
  users = [
    data.ignition_user.pass.id,
    data.ignition_user.gps.id,
  ]
}

data "ignition_filesystem" "data" {
  name = "data"
  mount {
    device = "/dev/disk/by-label/data"
    format = "ext4"
  }
}

data "ignition_systemd_unit" "data_resize" {
  name    = "data-resize.service"
  content = <<EOF
[Unit]
Description=Resize data volume filesystem to fill partition
DefaultDependencies=no
Before=data.mount

[Service]
Type=oneshot
ExecStart=/usr/sbin/e2fsck -pf /dev/disk/by-label/data
ExecStart=/usr/sbin/resize2fs /dev/disk/by-label/data

[Install]
WantedBy=local-fs.target
EOF
}

data "ignition_systemd_unit" "data_mount" {
  name    = "data.mount"
  content = <<EOF
[Unit]
Description=Persistent data (/data)

[Mount]
What=/dev/disk/by-label/data
Where=/data

[Install]
WantedBy=local-fs.target
EOF
}

data "ignition_file" "sshd_config" {
  filesystem = "root"
  path       = "/etc/ssh/sshd_config"
  mode       = 420
  content {
    content = <<EOF
# Use most defaults for sshd configuration.
Subsystem sftp internal-sftp
ClientAliveInterval 180
UseDNS no
UsePAM yes
PrintLastLog no # handled by PAM
PrintMotd no # handled by PAM

# Custom configuration
Match User ${data.ignition_user.pass.name},${data.ignition_user.gps.name}
    AuthorizedKeysFile /etc/ssh/authorized_keys/%u
    AllowTcpForwarding no
EOF
  }
}

data "ignition_directory" "authorized_keys" {
  filesystem = "root"
  path       = "/etc/ssh/authorized_keys"
  mode       = 493
}

data "ignition_user" "pass" {
  name           = "pass"
  home_dir       = "/data/pass"
  no_create_home = true
  shell          = "/usr/bin/git-shell"
  uid            = 1010
}

data "ignition_file" "pass_auth" {
  filesystem = "root"
  path       = "/etc/ssh/authorized_keys/${data.ignition_user.pass.name}"
  mode       = 420
  content {
    content = <<EOF
%{for _, key in var.ssh_keys~}
${key}
%{endfor~}
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw/nzdTrfL01ZEeFn3Os7XCOb8prZWp+5h5m5pfpDKX8qUoI+cELF4p+u8bkzSONFBoFYAbvzRgW9QkBCRnopyLY4c7q5R+Rxy4CqwhfaLzFL1Ova8uBsEhEHhEwhwX+kWG/hDCbq6AppStw+JCNkWOcj0fjntfucGoqRbrv9kS4+y1JjgvFMQeHaKif0ZILb/SivhHGMaJpApyHWx8kmkDm0AFjb3Gx0BZBX1atQHi+l8yfcJpDMwm50M3KH1PDWL1GGleqjV+yQ5XGlh2VXV7CyUTrE/yRnchl6M+831Btq1SvrfmagZ46xRDSFEKWvsevYC72HvwfpcxsYv5yPTETGnI2/vE2lAihI44vg8u1uJ3TkPJKfu8zXRUy3VAwOaSQNc5J09RSQY2x9UMCNq7XUGTlz1p1BdzMulpJRMj7oZI0wqzqsvNGRvG+jw8lxei1k38OztTXvDbf7P7/mM77jYLC7uorWASFQ3D5TgXDnb8dpRo8h8BX65UlE6pG3bbndI5wKrqdjt/mACDdYBzPkc8dRz7MYs1HYFnv8BbzKLRNr6qMAsEj5Q9nNtKsfd2ZONE6Ce+fHrIFMMHyPTikFqyXm8/65YVW0OemP3I93GJdkvRevkb8hq380ABwGcS+EwyV5EIfEI0bUWJFw2/ZQo2Y+988AfJ9P0qeBHWw== jaan@oneplus5t
EOF
  }
}

data "ignition_directory" "data_pass" {
  filesystem = "data"
  path       = "/pass"
  mode       = 493
  uid        = data.ignition_user.pass.uid
}

data "ignition_systemd_unit" "pass" {
  name    = "password-store.service"
  content = <<EOF
[Unit]
Description=Initialize password store

[Service]
Type=oneshot
User=${data.ignition_user.pass.name}
UMask=0077
ExecStart=/usr/bin/git init --bare ${data.ignition_user.pass.home_dir}/password-store.git

[Install]
WantedBy=multi-user.target
EOF
}

data "ignition_user" "gps" {
  name           = "gps"
  home_dir       = "/data/gps"
  no_create_home = true
  uid            = 1011
}

data "ignition_file" "gps_auth" {
  filesystem = "root"
  path       = "/etc/ssh/authorized_keys/${data.ignition_user.gps.name}"
  mode       = 420
  content {
    content = <<EOF
%{for _, key in var.ssh_keys~}
${key}
%{endfor~}
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHIoP5UCYh1+K432lXEk7QhiPKVa23QEtASPXLhAf54zqRy3BYWvjJRSxaJHUqxGIvc7j1SY0PbeRG9idq+XZclxjFGTsOeLqFJ/eFIt8DFD/HNrDa5pwGH7MznAbD/kYxm641D+UMiBphROfDdMFN4bQv12Bj6Tamq+be29uTUAZABanhKndmKFm2cKs9C1G7Q4EaNMYfVn9Exzy6DzulwgW+8HhPrU5imeTlFNMJIn6DTCsdc8mZ6zUF+1sp5+gCST+GahNyFGqY8cgBs1UeJ5fcgyoe8Bnl/i5OGK931pWdz2IMs1dE/Gxmj6kvJvxdiOKtVUXO+nS5ebOTP/dH gpslogger@oneplus5t
EOF
  }
}

data "ignition_directory" "data_gps" {
  filesystem = "data"
  path       = "/gps"
  mode       = 493
  uid        = data.ignition_user.gps.uid
}

data "ignition_directory" "data_taskd" {
  filesystem = "data"
  path       = "/taskd"
  mode       = 1023
}

data "ignition_file" "docker_auth" {
  filesystem = "root"
  path       = "/etc/rkt/auth.d/docker.json"
  content {
    content = <<EOF
{
    "rktKind": "dockerAuth",
    "rktVersion": "v1",
    "registries": ["docker.pkg.github.com"],
    "credentials": {
        "user": "jaantoots",
        "password": "${var.github_pkg_token}"
	}
}
EOF
  }
}

data "ignition_systemd_unit" "taskserver" {
  name    = "taskserver.service"
  content = <<EOF
[Unit]
Description=taskserver

[Service]
Slice=machine.slice
ExecStart=/usr/bin/rkt run --insecure-options=image \
    --volume=volume-var-lib-taskd,kind=host,source=/data/taskd \
    --port=53589-tcp:53589 \
    --set-env=TASKD_ORGANIZATION=jxyz \
    --set-env=TASKD_CN=task.${cloudflare_zone.jaan_xyz.zone} \
    --set-env=TASKD_COUNTRY=EE \
    --set-env=TASKD_STATE=Harju \
    --set-env=TASKD_LOCALITY=Tallinn \
    docker://docker.pkg.github.com/jaantoots/infrastructure/taskserver:1.0.0
KillMode=mixed
Restart=always

[Install]
WantedBy=multi-user.target
EOF
}

data "ignition_directory" "data_caddy" {
  filesystem = "data"
  path       = "/caddy"
  mode       = 1023
}

data "ignition_file" "caddyfile" {
  filesystem = "data"
  path       = "/caddy/Caddyfile"
  mode       = 420
  content {
    content = <<EOF
http://archlinux.${cloudflare_zone.jaan_xyz.zone}, https://archlinux.${cloudflare_zone.jaan_xyz.zone} {
    errors
    log
    browse
    root /srv/http/archlinux
}

https://web.${cloudflare_zone.jaan_xyz.zone} {
    errors
    log
    markdown
    root /srv/http/web
}
EOF
  }
}

data "ignition_directory" "data_http" {
  filesystem = "data"
  path       = "/http"
  mode       = 493
  uid        = 500
  gid        = 500
}

data "ignition_directory" "data_http_archlinux" {
  filesystem = "data"
  path       = "/http/archlinux"
  mode       = 493
  uid        = 500
  gid        = 500
}

data "ignition_directory" "data_http_web" {
  filesystem = "data"
  path       = "/http/web"
  mode       = 493
  uid        = 500
  gid        = 500
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
    docker://docker.pkg.github.com/jaantoots/infrastructure/caddy:1.0.3 -- -agree -email ${var.acme_email}
KillMode=mixed
Restart=always

[Install]
WantedBy=multi-user.target
EOF
}

resource "digitalocean_firewall" "cloud" {
  name        = "cloud"
  droplet_ids = [digitalocean_droplet.cloud.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "53589"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "cloudflare_record" "task" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "task"
  type    = "CNAME"
  value   = cloudflare_record.cloud.hostname
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

resource "cloudflare_record" "cloud" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "cloud"
  type    = "A"
  value   = digitalocean_droplet.cloud.ipv4_address
}

resource "cloudflare_record" "cloud6" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "cloud"
  type    = "AAAA"
  value   = digitalocean_droplet.cloud.ipv6_address
}
