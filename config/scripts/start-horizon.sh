#!/bin/sh

set -e

sudo -u nobody -g nobody php artisan horizon
exit 1e