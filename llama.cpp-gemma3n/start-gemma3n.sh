#!/usr/bin/env bash
set -euo pipefail

# Config via env:
#  - DATA_DIR (default: /data/models)
#  - MODEL_REPO (default: bartowski/google_gemma-3n-E4B-it-GGUF)
#  - MODEL_FILE (default: google_gemma-3n-E4B-it-Q4_K_M.gguf)
#  - HOST, PORT, CTX, NGL, THREADS
#  - HF_TOKEN (optional; used for private/ratelimited repos)

DATA_DIR="${DATA_DIR:-/data/models}"
MODEL_REPO="${MODEL_REPO:-bartowski/google_gemma-3n-E4B-it-GGUF}"
MODEL_FILE="${MODEL_FILE:-google_gemma-3n-E4B-it-Q4_K_M.gguf}"
HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8080}"
CTX="${CTX:-2048}"
NGL="${NGL:-999}"
THREADS="${THREADS:-$(nproc)}"

mkdir -p "$DATA_DIR"

if [ ! -f "$DATA_DIR/$MODEL_FILE" ]; then
  echo "[start] downloading $MODEL_FILE from $MODEL_REPO -> $DATA_DIR"
  # If HF_TOKEN is provided, expose it to hf via env (no interactive login)
  if [ -n "${HF_TOKEN:-}" ]; then
    export HUGGING_FACE_HUB_TOKEN="$HF_TOKEN"
  fi
  hf download "$MODEL_REPO" \
    --include "$MODEL_FILE" \
    --local-dir "$DATA_DIR"
  if [ ! -f "$DATA_DIR/$MODEL_FILE" ]; then
    echo "[start] ERROR: model file not found after download. Check MODEL_REPO/MODEL_FILE/HF_TOKEN."
    exit 2
  fi
fi

echo "[start] launching llama-server on $HOST:$PORT (ctx=$CTX, ngl=$NGL, threads=$THREADS)"
exec llama-server --host "$HOST" --port "$PORT" \
  -m "$DATA_DIR/$MODEL_FILE" \
  -c "$CTX" -ngl "$NGL" --threads "$THREADS" --parallel 1
