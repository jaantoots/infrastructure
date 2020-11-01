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

resource "aws_security_group_rule" "cloud_allow_icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
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
  security_groups   = [aws_security_group.cloud.name]
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
  sshKeysDefault = [ %{for name, key in var.ssh_keys~} sshKeys.${name} %{endfor~} ];
in
{
  # Enable automatic updates and gc
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

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
    openssh.authorizedKeys.keys = sshKeysDefault ++ [ sshKeys.pass ];
  };
  systemd.services.password-store = {
    description = "Initialize password store";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.gitMinimal ];
    script = "git init --bare ~/password-store.git";
    serviceConfig = {
      Type = "oneshot";
      User = "$${config.users.users.pass.name}";
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
    "d /data/gps/gpslogger - $${config.users.users.gps.name} $${config.users.users.gps.group} - -"
    "d /data/http - root root - -"
    "d /data/http/archlinux - $${config.users.users.arch.name} $${config.users.users.arch.group} - -"
  ];

  # Web server
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme.acceptTerms = true;
  security.acme.email = "${var.acme_email}";
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "${cloudflare_record.archlinux.hostname}" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          root = "/srv/http/archlinux";
          extraConfig = "autoindex on;";
        };
      };
    };
  };
  fileSystems."/srv/http" = {
    device = "/data/http";
    fsType = "none";
    options = [ "bind" "ro" ];
  };
}
EOF
}
