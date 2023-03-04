#!/bin/sh

set -e

LARAVEL_TYPE=${LARAVEL_TYPE:-laravel}
APP_ENV=${APP_ENV:-production}

echo "Laravel: $APP_ENV"

if [ "$LARAVEL_TYPE" = 'laravel' ]; then
    if [ "$APP_ENV" != "local" ]; then
        echo "Caching configuration"
        (
            sudo -u nobody -g nobody php artisan config:cache &&
            sudo -u nobody -g nobody php artisan view:cache &&
            sudo -u nobody -g nobody php artisan route:cache
        )
    else
        echo "Clear configuration"
        (
            sudo -u nobody -g nobody php artisan config:clear &&
            sudo -u nobody -g nobody php artisan view:clear &&
            sudo -u nobody -g nobody php artisan route:clear
        )
    fi
fi