#!/bin/sh

set -e

# External user
CONTAINER_USER=${CONTAINER_USER:-1000}
CONTAINER_USER_GROUP=${CONTAINER_USER_GROUP:-1000}

# Run PHP-FPM as current user
if [ ! -z "$CONTAINER_USER" ]; then
    sed -i "s/65534:65534/$CONTAINER_USER:$CONTAINER_USER_GROUP/g" /etc/passwd
fi

if [ ! -z "$CONTAINER_USER_GROUP" ]; then
    sed -i "s/65534/$CONTAINER_USER_GROUP/g" /etc/group
fi