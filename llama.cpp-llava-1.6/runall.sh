#!/bin/env sh



docker rm -f llava_1_6_7b >|/dev/null || true
docker compose build --no-cache
docker compose up -d --force-recreate
