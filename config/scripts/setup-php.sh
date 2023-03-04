#!/bin/sh

set -e

APP_ENV=${APP_ENV:-production}

# Cache configuration
if [ "$APP_ENV" != "local" ]; then
    cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/conf.d/php.ini

else
    echo "Dev: Opcache disabled."
    (
        sed -i "s/opcache.validate_timestamps=0/opcache.validate_timestamps=1/g" /usr/local/etc/php/conf.d/opcache.ini &&
        cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/conf.d/php.ini
    )
fi

# PHP config ...
PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-256M}

# Configure PHP ...
if [ "$PHP_MEMORY_LIMIT" != "256M" ]; then
echo "memory_limit = $PHP_MEMORY_LIMIT" > /usr/local/etc/php/conf.d/memory-limit.ini
fi
