#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data/models}"
REPO="${MODEL_REPO:-bartowski/Qwen2-VL-2B-Instruct-GGUF}"
MODEL_FILE="${MODEL_FILE:-Qwen2-VL-2B-Instruct-Q4_K_M.gguf}"
MMPROJ_FILE="${MMPROJ_FILE:-mmproj-Qwen2-VL-2B-Instruct-f16.gguf}"

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8080}"
CTX="${CTX:-1024}"
NGL="${NGL:-999}"
THREADS="${THREADS:-$(nproc)}"

mkdir -p "$DATA_DIR/qwen2vl-2b"
cd "$DATA_DIR/qwen2vl-2b"

# Non-interactive HF auth (optional)
if [ -n "${HF_TOKEN:-}" ]; then export HUGGING_FACE_HUB_TOKEN="$HF_TOKEN"; fi

# Download GGUF + mmproj wenn nicht vorhanden
[ -f "$MODEL_FILE" ] || hf download "$REPO" --include "$MODEL_FILE" --local-dir .
[ -f "$MMPROJ_FILE" ] || hf download "$REPO" --include "$MMPROJ_FILE" --local-dir .

echo "[start] launching llama-server (Qwen2-VL-2B) on $HOST:$PORT"
exec llama-server --host "$HOST" --port "$PORT" \
  -m "$DATA_DIR/qwen2vl-2b/$MODEL_FILE" \
  --mmproj "$DATA_DIR/qwen2vl-2b/$MMPROJ_FILE" \
  -c "$CTX" -ngl "$NGL" --threads "$THREADS" --parallel 1
