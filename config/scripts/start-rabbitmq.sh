#!/bin/sh

set -e

# RabbitMQ config ...
RABBITMQ_CONSUMER_CONNECTION=${RABBITMQ_CONSUMER_CONNECTION:-rabbitmq}

echo "Running rabbitmq ..."
    
sudo -u nobody -g nobody php artisan rabbitmq:consume \
    ${RABBITMQ_CONSUMER_CONNECTION}