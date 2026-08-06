#!/usr/bin/env bash

set -euo pipefail

mkdir -p "${DATA_DIR}"

model_path="${DATA_DIR}/${MODEL_FILE}"
mmproj_path="${DATA_DIR}/${MMPROJ_FILE}"

if [[ ! -s "${model_path}" || ! -s "${mmproj_path}" ]]; then
    echo "Downloading ${MODEL_REPO}..."

    hf download \
        "${MODEL_REPO}" \
        "${MODEL_FILE}" \
        "${MMPROJ_FILE}" \
        --local-dir "${DATA_DIR}"
fi

if [[ ! -s "${model_path}" ]]; then
    echo "Model not found: ${model_path}" >&2
    exit 1
fi

if [[ ! -s "${mmproj_path}" ]]; then
    echo "Vision projector not found: ${mmproj_path}" >&2
    exit 1
fi

echo "Starting ${MODEL_ALIAS}"
echo "Model:  ${model_path}"
echo "MMProj: ${mmproj_path}"
echo "Context: ${CTX}"
echo "Image tokens: ${IMAGE_MIN_TOKENS}-${IMAGE_MAX_TOKENS}"

exec llama-server \
    --model "${model_path}" \
    --mmproj "${mmproj_path}" \
    --alias "${MODEL_ALIAS}" \
    --host "${HOST}" \
    --port "${PORT}" \
    --ctx-size "${CTX}" \
    --gpu-layers "${NGL}" \
    --threads "${THREADS}" \
    --threads-batch "${THREADS_BATCH}" \
    --parallel "${PARALLEL}" \
    --batch-size "${BATCH}" \
    --ubatch-size "${UBATCH}" \
    --cache-type-k "${CACHE_TYPE_K}" \
    --cache-type-v "${CACHE_TYPE_V}" \
    --flash-attn "${FLASH_ATTN}" \
    --image-min-tokens "${IMAGE_MIN_TOKENS}" \
    --image-max-tokens "${IMAGE_MAX_TOKENS}" \
    --mtmd-batch-max-tokens "${MTMD_BATCH_MAX_TOKENS}" \
    --cache-ram 0 \
    --reasoning off \
    --temperature 0 \
    "$@"
