#!/bin/sh

set -eux

if [ ! -f "$TASKDDATA/config" ]; then
    # Generate certificates
    if [ ! -d "$TASKDDATA/pki" ]; then
        mkdir "$TASKDDATA/pki"
        cp /usr/share/taskd/pki/generate.* "$TASKDDATA/pki/"
        cat >"$TASKDDATA/pki/vars" <<EOF
BITS=4096
EXPIRATION_DAYS=365
ORGANIZATION="$TASKD_ORGANIZATION"
CN="$TASKD_CN"
COUNTRY="$TASKD_COUNTRY"
STATE="$TASKD_STATE"
LOCALITY="$TASKD_LOCALITY"
EOF
        (cd "$TASKDDATA/pki" && \
            ./generate.ca && \
            ./generate.server && \
            ./generate.crl && \
            ./generate.client)
    fi

    # Initialise configuration
    taskd init

    # Configure taskserver certificates
    taskd config --force ca.cert     "$TASKDDATA/pki/ca.cert.pem"
    taskd config --force server.cert "$TASKDDATA/pki/server.cert.pem"
    taskd config --force server.key  "$TASKDDATA/pki/server.key.pem"
    taskd config --force server.crl  "$TASKDDATA/pki/server.crl.pem"
    taskd config --force client.cert "$TASKDDATA/pki/client.cert.pem"
    taskd config --force client.key  "$TASKDDATA/pki/client.key.pem"

    # Other configuration
    taskd config --force log -
    taskd config --force server 0.0.0.0:53589
fi

exec taskd server "$@"
