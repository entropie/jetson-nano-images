#!/bin/env sh

docker rm -f gemma34b 2>|/dev/null || true
docker build -t gemma34b-gguf-server . --no-cache
docker compose up -d
#docker compose logs -f gemma34b
#docker run -d --name gemma34b --device nvidia.com/gpu=all -v /data:/data -e HF_TOKEN="$HF_TOKEN" -e MODEL_REPO="bartowski/google_gemma-3-4b-it-GGUF" -e MODEL_FILE="google_gemma-3-4b-it-Q5_K_M.gguf" -e MMPROJ_FILE="mmproj-google_gemma-3-4b-it-f16.gguf" -p 8092:8080 gemma34b-gguf-server
