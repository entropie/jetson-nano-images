#!/bin/env sh

docker rm -f gemma34b 2>|/dev/null || true
docker compose up -d
#docker compose logs -f gemma34b
