#!/bin/sh

apk add --no-cache zip libzip-dev

docker-php-ext-configure zip
docker-php-ext-install zip