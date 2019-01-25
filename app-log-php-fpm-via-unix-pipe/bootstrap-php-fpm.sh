#!/bin/sh

# Create a pipe used by the PHP app to write logs
if [ ! -p /var/log/shared/pipe-from-app-to-stdout ]; then
    mkfifo      /var/log/shared/pipe-from-app-to-stdout
    chmod 777   /var/log/shared/pipe-from-app-to-stdout
fi

exec php-fpm7 --fpm-config /etc/php7/php-fpm.conf --php-ini /etc/php7/php.ini
