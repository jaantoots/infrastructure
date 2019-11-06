# Taskserver

The Dockerfile prepares a taskserver according to the
[documentation](https://taskwarrior.org/docs/#taskd), using the values provided
in the environment to set up the server.

Initial configuration requires creating organizations, groups and users:

```shell
taskd add org jxyz
taskd add user jxyz jaan
cd /var/lib/taskd/pki/ && ./generate.client jaan
```
