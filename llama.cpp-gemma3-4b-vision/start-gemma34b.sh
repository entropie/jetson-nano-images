#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data/models}"
REPO="${MODEL_REPO:-bartowski/google_gemma-3-4b-it-GGUF}"
MODEL_FILE="${MODEL_FILE:-gemma-3-4b-it-Q5_K_M.gguf}"
MMPROJ_FILE="${MMPROJ_FILE:-mmproj-gemma-3-4b-it-f16.gguf}"

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8080}"
CTX="${CTX:-1024}"
NGL="${NGL:-999}"
THREADS="${THREADS:-$(nproc)}"

mkdir -p "$DATA_DIR/gemma3-4b"
cd "$DATA_DIR/gemma3-4b"

if [ -n "${HF_TOKEN:-}" ]; then export HUGGING_FACE_HUB_TOKEN="$HF_TOKEN"; fi

[ -f "$MODEL_FILE" ]  || hf download "$REPO" --include "$MODEL_FILE"  --local-dir .
[ -f "$MMPROJ_FILE" ] || hf download "$REPO" --include "$MMPROJ_FILE" --local-dir .

echo "[start] launching llama-server (Gemma-3-4B Vision) on $HOST:$PORT"
exec llama-server --host "$HOST" --port "$PORT" \
  -m "$DATA_DIR/gemma3-4b/$MODEL_FILE" --jinja \
  --mmproj "$DATA_DIR/gemma3-4b/$MMPROJ_FILE" \
  -c "$CTX" -ngl "$NGL" --threads "$THREADS" --parallel 1
