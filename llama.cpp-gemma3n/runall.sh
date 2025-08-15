#!/bin/sh

docker build -t gemma3n-gguf-server .

docker run -d --name gemma3n --device nvidia.com/gpu=all -v /data:/data -e HF_TOKEN="${$HF_TOKEN}" -p 8080:8080 gemma3n-gguf-server
