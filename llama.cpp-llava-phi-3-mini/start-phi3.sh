#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data/models}"
REPO="${MODEL_REPO:-xtuner/llava-phi-3-mini-gguf}"
MODEL_FILE="${MODEL_FILE:-llava-phi-3-mini-int4.gguf}"
MMPROJ_FILE="${MMPROJ_FILE:-llava-phi-3-mini-mmproj-f16.gguf}"

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8080}"
CTX="${CTX:-2048}"
NGL="${NGL:-999}"
THREADS="${THREADS:-6}"

MODEL_DIR="$DATA_DIR/llava-phi-3-mini"
mkdir -p "$MODEL_DIR"
cd "$MODEL_DIR"

# Non-interactive HF auth (optional)
if [ -n "${HF_TOKEN:-}" ]; then export HUGGING_FACE_HUB_TOKEN="$HF_TOKEN"; fi

# Download GGUF + mmproj wenn nicht vorhanden
[ -f "$MODEL_FILE" ] || hf download "$REPO" --include "$MODEL_FILE" --local-dir .
[ -f "$MMPROJ_FILE" ] || hf download "$REPO" --include "$MMPROJ_FILE" --local-dir .

echo "[start] launching llama-server (llava-phi-3-mini) on $HOST:$PORT"
# Das --jinja-Flag wurde entfernt, da Chat-Vorlagen oft in der GGUF-Datei eingebettet sind.
exec llama-server --host "$HOST" --port "$PORT" \
  -m "$MODEL_DIR/$MODEL_FILE" --jinja \
  --mmproj "$MODEL_DIR/$MMPROJ_FILE" \
  -c "$CTX" -ngl "$NGL" --threads "$THREADS" --parallel 1
