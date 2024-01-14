#!/bin/sh

if [ "$1" = 'dev' ]; then
    cd /app
    bundle install
    exec "$2"
elif [ "$1" = 'server' ]; then
    cd /app
    make database-check
    exec /app/bin/rails server -p $PORT -b 0.0.0.0 --environment=production --no-log-to-stdout
elif [ "$1" = 'migrate_and_server' ]; then
    cd /app
    make database-check
    /app/bin/rails db:drop db:create db:migrate
    exec /app/bin/rails server -p $PORT -b 0.0.0.0 --environment=production --no-log-to-stdout
fi
