#!/bin/env sh

docker rm -f llava_phi_3_mini 2>|/dev/null || true
docker build -t llava_phi_3_mini . --no-cache
docker compose up -d
