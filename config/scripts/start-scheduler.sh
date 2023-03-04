#!/bin/sh

set -e

while [ true ]
do
    sudo -u nobody -g nobody php artisan schedule:run --verbose --no-interaction &
    sleep 60
done

exit 1