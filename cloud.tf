resource "aws_key_pair" "cloud" {
  key_name   = "cloud"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBX3YVqV+WaNW1EbD6qTdEROpMcfLEOXWTFLMwaU5kZecGu6qKdMNJTroBxrS4IqaKqCCgZiUwJQQ+UOC1j9RwCRnHbeWnT5iJxSqvsPFN/qtSHJaua6PptRuAQ7ar+/rd/jpKTp1VUMonJ7urHoi7FbgoFdsq6mtKNzdEuMtNmNNB5ajVIasoIbJBhc3BQ4DYRCIAtkpUmpoH2fwXIgo1mBtvB8hz/sFlWladCB3hqwzkpgZt1dfB7qRHV7TZapmQGygThjIFZPVufO+CZ2jmrQUWmom1XgFP9TyuwMbgGO7QoRFPMV6ikrVioJImuNdYCo/pDO+/zuKdS3ErJFxo8S2c8zsIJhqh4sO193V3taYLm4GbsAofOU4WuIahPmNNn8Qi+U71oK0/6BI3CfMNPHnqW+p3NC4zHZef40os68V8YiwYB/pboRFOC6WuYHXAIpnaUrQm+WoEn49m4r52ym5UbxWlZTr7vv/WjwmJe0W2jewWA0VvQmAF2I/1kvE= jaan-cloud"
}

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
    openssh.authorizedKeys.keys = sshKeysDefault ++ [ sshKeys.pass sshKeys.ipad sshKeys.iphone ];
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

  # Create directories
  systemd.tmpfiles.rules = [
    "d /data/gps/gpslogger - $${config.users.users.gps.name} $${config.users.users.gps.group} - -"
    "d /data/http - root root - -"
  ];
}
EOF
}
