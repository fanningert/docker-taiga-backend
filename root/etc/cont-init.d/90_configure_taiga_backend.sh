#!/usr/bin/with-contenv bash

mkdir -p /config

dockerize -template /app/start_taiga_backend.sh:/config/start_taiga_backend.sh
dockerize -template /app/local.py:/home/app/taiga-back/settings/local.py

chmod +x /config/start_taiga_backend.sh

chown -R app:users /config
