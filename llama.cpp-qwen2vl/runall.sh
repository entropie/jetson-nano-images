#!/bin/env sh

docker rm -f qwen2 2>|/dev/null || true
docker build -t qwen2-gguf-server . --no-cache
docker compose up -d
