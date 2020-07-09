resource "aws_security_group" "cloud" {
  name        = "cloud"
  description = "Cloud security group"
}

resource "aws_security_group_rule" "cloud_allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cloud.id
}

resource "aws_security_group_rule" "cloud_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cloud.id
}

resource "aws_security_group_rule" "cloud_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cloud.id
}

resource "aws_security_group_rule" "cloud_allow_ping" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cloud.id
}

resource "aws_security_group_rule" "cloud_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cloud.id
}

resource "aws_instance" "cloud" {
  ami               = "ami-02c34db5766cc7013"
  availability_zone = "eu-west-1a"
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.cloud.key_name
  security_groups   = ["${aws_security_group.cloud.name}"]
  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "cloud"
  }
}

resource "aws_ebs_volume" "cloud_data" {
  availability_zone = "eu-west-1a"
  size              = 10
}

resource "aws_volume_attachment" "cloud_data" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.cloud.id
  volume_id   = aws_ebs_volume.cloud_data.id
}

resource "cloudflare_record" "cloud" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "cloud"
  type    = "A"
  value   = aws_instance.cloud.public_ip
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

resource "local_file" "cloud" {
  filename        = "${path.module}/cloud.nix"
  file_permission = "0644"
  content         = <<EOF
{ config, pkgs, ... }:

let
  sshKeys = {
%{for name, key in var.ssh_keys~}
    ${name} = "${key}";
%{endfor~}
%{for name, key in var.ssh_keys_extra~}
    ${name} = "${key}";
%{endfor~}
  };
  sshKeysDefault = [ sshKeys.caracal sshKeys.falstaff sshKeys.gpd ];
in
{
  # Enable automatic updates
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Define system
  programs.vim.defaultEditor = true;
  environment.systemPackages = [ pkgs.gitMinimal ];
  fileSystems."/data" = {
    device = "/dev/sdh";
    fsType = "ext4";
    autoFormat = true;
    autoResize = true;
  };

  # Password store
  users.users.pass = {
    createHome = true;
    home = "/data/pass";
    shell = "/run/current-system/sw/bin/git-shell";
    openssh.authorizedKeys.keys = sshKeysDefault ++ [ sshKeys.oneplus5t ];
  };
  systemd.services.password-store = {
    description = "Initialize password store";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.gitMinimal ];
    script = "git init --bare ~/password-store.git";
    serviceConfig = {
      Type = "oneshot";
      User = "pass";
      UMask = "0077";
    };
  };

  # GPS tracks
  users.users.gps = {
    createHome = true;
    home = "/data/gps";
    useDefaultShell = true;
    openssh.authorizedKeys.keys = sshKeysDefault ++ [ sshKeys.gpslogger ];
  };

  # Arch package repository
  users.users.arch = {
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [ sshKeys.falstaff ];
  };

  # Create directories
  systemd.tmpfiles.rules = [
    "d /data/gps/gpslogger - gps nogroup - -"
    "d /data/http - root root - -"
    "d /data/http/archlinux - arch root - -"
  ];

  # Web server
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme.acceptTerms = true;
  security.acme.email = "${var.acme_email}";
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "${cloudflare_record.web.hostname}" = {
        default = true;
        forceSSL = true;
        enableACME = true;
        locations."/".root = "/srv/http/web";
        extraConfig = ''
          location ~ "^/photos/(jpeg|tiff)" {
            return 301 "https://${cloudflare_record.cdn.hostname}/file/jaan-public$request_uri";
          }
        '';
      };

      "${cloudflare_record.archlinux.hostname}" = {
        addSSL = true;
        useACMEHost = "${cloudflare_record.web.hostname}";
        locations."/" = {
          root = "/srv/http/archlinux";
          extraConfig = "autoindex on;";
        };
      };
    };
  };
  security.acme.certs."${cloudflare_record.web.hostname}".extraDomains."${cloudflare_record.archlinux.hostname}" = null;
  fileSystems."/srv/http" = {
    device = "/data/http";
    fsType = "none";
    options = [ "bind" "ro" ];
  };
}
EOF
}
