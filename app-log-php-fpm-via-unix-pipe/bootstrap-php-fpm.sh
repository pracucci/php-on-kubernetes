#!/bin/sh
#
# This script is run as PID 1 and is the entry point used to run the webserver.
#

# Create a pipe to forward logs from the PHP app to PID 1's stdout
# IMPORTANT: do NOT create the FIFO in the Dockerfile, otherwise the FIFO
#            is shared across all pods running the same exact image on the
#            same node (still didn't understand how it works under the hood)
if [ ! -p /var/log/pipe-from-app-to-stdout ]; then
    mkfifo      /var/log/pipe-from-app-to-stdout
    chmod 777   /var/log/pipe-from-app-to-stdout
fi

# Gracefully shutdown on SIGTERM
graceful_shutdown() {
    if [ ! -e /var/run/php-fpm.pid ]; then
        exit 0
    fi

    # Send a SIGQUIT to gracefully shutdown php-fpm
    kill -SIGQUIT "$(cat /var/run/php-fpm.pid)"

    # Wait until php-fpm has been terminated (no timeout, since
    # Kubernetes will SIGKILL the container once the grace termination
    # period expires)
    while [ -e /var/run/php-fpm.pid ]; do
        sleep 0.2
    done

    exit 0
}

trap "graceful_shutdown" TERM

# Start PHP FPM (it daemonize) and redirect its stderr to PID1 stderr
php-fpm7 --fpm-config /etc/php7/php-fpm.conf --php-ini /etc/php7/php.ini 2>&2

# Read app logs from the pipe in background and forward them to PID1 stdout
tail -f /var/log/pipe-from-app-to-stdout 1>&1 &
TAIL_PID=$!

# Leave some time to PHP FPM to write the pid file and start up
sleep 3

# Wait indefinitely (and run the shutdown trap on SIGTERM), but exit
# immediately with an error if tail process dies, because if we don't read
# from the pipe, writing to the pipe will block indefinitely
while true; do
    if [ ! -e "/proc/${TAIL_PID}" ]; then
        echo "tail process is not running" >> /dev/stderr
        exit 1
    fi

    if [ ! -e /var/run/php-fpm.pid -o ! -e "/proc/$(cat /var/run/php-fpm.pid)" ]; then
        echo "php-fpm process is not running" >> /dev/stderr
        exit 1
    fi

    sleep 1
done
