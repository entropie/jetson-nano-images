#!/bin/env sh



docker rm -f llava-1.6-7b-server >|/dev/null || true
docker compose build --no-cache
docker compose up -d --force-recreate
