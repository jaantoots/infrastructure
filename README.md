# Personal infrastructure setup

Personal cloud infrastructure managed by Terraform.

## Cloud server

Upload configuration:

```
scp -i .id_cloud cloud.nix root@cloud.jaan.xyz:/etc/nixos/
```

Initial setup:

```
ssh -i .id_cloud root@cloud.jaan.xyz sed -i '/imports/s/];/.\/cloud.nix \0/' /etc/nixos/configuration.nix
```
