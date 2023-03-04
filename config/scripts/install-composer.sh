#!/bin/sh

apk add --no-cache --upgrade openssh curl git

mkdir /root/.ssh
touch /root/.ssh/known_hosts
/usr/bin/ssh-keyscan gitlab.com >> /root/.ssh/known_hosts