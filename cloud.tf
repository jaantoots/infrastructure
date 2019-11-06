resource "digitalocean_droplet" "cloud" {
  image     = "coreos-stable"
  name      = "cloud.jaan.xyz"
  region    = "ams3"
  size      = "s-1vcpu-1gb"
  ipv6      = true
  ssh_keys  = [for key in digitalocean_ssh_key.keys : key.fingerprint]
  user_data = "${data.ignition_config.cloud.rendered}"
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
  droplet_id = "${digitalocean_droplet.cloud.id}"
  volume_id  = "${digitalocean_volume.cloud.id}"
}

data "ignition_config" "cloud" {
  filesystems = [
    "${data.ignition_filesystem.cloud_data.id}",
  ]
  directories = [
    "${data.ignition_directory.data_taskd.id}",
  ]
  files = [
    "${data.ignition_file.docker_auth.id}",
  ]
  systemd = [
    "${data.ignition_systemd_unit.data_mount.id}",
    "${data.ignition_systemd_unit.taskserver.id}",
  ]
}

data "ignition_filesystem" "cloud_data" {
  name = "data"
  mount {
    device = "/dev/disk/by-label/data"
    format = "ext4"
  }
}

data "ignition_directory" "data_taskd" {
  filesystem = "data"
  path       = "/taskd"
  mode       = 1023
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
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "task"
  type    = "CNAME"
  value   = "${cloudflare_record.cloud.hostname}"
}

resource "cloudflare_record" "cloud" {
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "cloud"
  type    = "A"
  value   = "${digitalocean_droplet.cloud.ipv4_address}"
}

resource "cloudflare_record" "cloud6" {
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "cloud"
  type    = "AAAA"
  value   = "${digitalocean_droplet.cloud.ipv6_address}"
}

resource "cloudflare_record" "www" {
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "www"
  type    = "CNAME"
  value   = "web.messagingengine.com"
  proxied = true
}

resource "cloudflare_record" "root" {
  zone_id = "${cloudflare_zone.jaan_xyz.id}"
  name    = "${cloudflare_zone.jaan_xyz.zone}"
  type    = "CNAME"
  value   = "www.${cloudflare_zone.jaan_xyz.zone}"
  proxied = true
}
