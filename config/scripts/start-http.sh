#!/bin/sh

set -e

# Application listening port
APP_PORT=${APP_PORT:-8000}

if [ "$CONTAINER_IMAGE_TYPE" = "nginx-fpm" ]; then
    cd ~/ && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
fi

# Octane config ...
OCTANE_WORKERS=${OCTANE_WORKERS:-auto}
OCTANE_TASK_WORKERS=${OCTANE_TASK_WORKERS:-auto}

if [ "$CONTAINER_IMAGE_TYPE" = "octane" ]; then
    echo "Running octane on port ${APP_PORT} ..."

    sudo -u nobody -g nobody php artisan octane:start \
        --host=0.0.0.0 \
        --port=${APP_PORT} \
        --workers=${OCTANE_WORKERS} \
        --task-workers=${OCTANE_TASK_WORKERS} \
        $([ "$APP_ENV" = "local" ] && printf '--watch')
fi