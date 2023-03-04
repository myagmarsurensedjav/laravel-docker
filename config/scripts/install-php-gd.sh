#!/bin/sh

apk add --no-cache libpng libjpeg-turbo libwebp freetype libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev

docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp
docker-php-ext-install gd

apk del libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev
rm -rf /var/cache/apk/*