#!/bin/sh

if [ "$1" = 'dev' ]; then
    cd /app
    bundle install
    exec "$2"
elif [ "$1" = 'server' ]; then
    cd app
    exec /app/bin/rails server
elif [ "$1" = 'migrate_and_server' ]; then
    cd app
    /app/bin/rails db:drop db:create db:migrate
    exec /app/bin/rails server
fi
