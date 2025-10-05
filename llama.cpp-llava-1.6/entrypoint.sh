#!/usr/bin/env bash
# --- Finale Version mit expliziter Parameter-Anzeige ---
set -euxo pipefail

# --- Diese Werte sind jetzt korrekt und verifiziert ---
DATA_DIR="/data/models"
MODEL_NAME="llava-1.6-7b"
REPO="cjpais/llava-v1.6-vicuna-7b-gguf"
MODEL_FILE="llava-v1.6-vicuna-7b.Q4_K_M.gguf"
MMPROJ_FILE="mmproj-model-f16.gguf"

HOST="0.0.0.0"
PORT="8080"
# PERFORMANCE-OPTIMIERUNG: Kontext reduziert, um VRAM freizugeben
CTX="4096"
# PERFORMANCE-OPTIMIERUNG: Alle Layer auf die GPU geladen für maximale Geschwindigkeit
NGL="30"
THREADS="6"

MODEL_DIR="$DATA_DIR/$MODEL_NAME"
echo "---[STEP 1]--- Preparing directory: $MODEL_DIR"
mkdir -p "$MODEL_DIR"
cd "$MODEL_DIR"

# --- URL-Konstruktion für wget ---
BASE_URL="https://huggingface.co/${REPO}/resolve/main"

echo "---[STEP 2]--- Checking/Downloading model file: $MODEL_FILE"
if [ ! -f "$MODEL_FILE" ]; then
    echo "Downloading model file with wget..."
    wget -c "${BASE_URL}/${MODEL_FILE}"
else
    echo "Model file found."
fi

echo "---[STEP 3]--- Checking/Downloading mmproj file: $MMPROJ_FILE"
if [ ! -f "$MMPROJ_FILE" ]; then
    echo "Downloading mmproj file with wget..."
    wget -c "${BASE_URL}/${MMPROJ_FILE}"
else
    echo "mmproj file found."
fi

echo "---[STEP 4]--- DIAGNOSTICS: Listing final files in directory:"
ls -lh .
echo "----------------------------------------------------------"

# --- DIAGNOSE-SCHRITT: Parameter vor dem Start anzeigen ---
echo "---[STEP 5]--- Launching server with the following parameters:"
echo "MODEL_FILE:  $MODEL_DIR/$MODEL_FILE"
echo "MMPROJ_FILE: $MODEL_DIR/$MMPROJ_FILE"
echo "CONTEXT (CTX): $CTX"
echo "GPU LAYERS (NGL): $NGL"
echo "----------------------------------------------------------"

exec llama-server --host "$HOST" --port "$PORT" \
  -m "$MODEL_DIR/$MODEL_FILE" \
  --mmproj "$MODEL_DIR/$MMPROJ_FILE" \
  --chat-template chatml \
  -c "$CTX" -ngl "$NGL" --threads "$THREADS" --cont-batching

