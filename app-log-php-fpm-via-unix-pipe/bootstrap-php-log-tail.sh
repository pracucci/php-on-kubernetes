#!/bin/sh

# Wait until the pipe - created by the PHP app container
# and shared via a tmp volume - is created
while [ ! -e /var/log/shared/pipe-from-app-to-stdout ]; do
    sleep 0.2
done

exec tail -f /var/log/shared/pipe-from-app-to-stdout
