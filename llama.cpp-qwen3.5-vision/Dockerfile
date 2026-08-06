FROM dustynv/l4t-pytorch:r36.4.0

ARG LLAMA_REF=master
ARG BUILD_JOBS=4

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
      cmake \
      build-essential \
      pkg-config \
      ca-certificates \
      curl \
      libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade --no-cache-dir \
      --index-url https://pypi.org/simple \
      --extra-index-url https://pypi.ngc.nvidia.com \
      "huggingface_hub[cli]" \
      pillow

RUN git clone --filter=blob:none \
      https://github.com/ggml-org/llama.cpp \
      /opt/llama.cpp \
    && cd /opt/llama.cpp \
    && git checkout "${LLAMA_REF}" \
    && cmake -S . -B build \
      -DGGML_CUDA=ON \
      -DGGML_CUDA_NO_VMM=ON \
      -DBUILD_SHARED_LIBS=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CUDA_ARCHITECTURES=87 \
    && cmake --build build \
      --target llama-server \
      -j"${BUILD_JOBS}" \
    && install -m0755 \
      build/bin/llama-server \
      /usr/local/bin/llama-server \
    && rm -rf /opt/llama.cpp

COPY start-qwen35-4b.sh /usr/local/bin/start-qwen35-4b.sh

RUN chmod 0755 /usr/local/bin/start-qwen35-4b.sh

ENV DATA_DIR=/data/models \
    HF_HOME=/data/models/.huggingface \
    MODEL_REPO=unsloth/Qwen3.5-4B-GGUF \
    MODEL_FILE=Qwen3.5-4B-Q4_K_M.gguf \
    MMPROJ_FILE=mmproj-F16.gguf \
    MODEL_ALIAS=qwen3.5-4b-vision \
    HOST=0.0.0.0 \
    PORT=8080 \
    CTX=8192 \
    NGL=all \
    THREADS=6 \
    THREADS_BATCH=6 \
    PARALLEL=1 \
    BATCH=1024 \
    UBATCH=256 \
    CACHE_TYPE_K=f16 \
    CACHE_TYPE_V=f16 \
    FLASH_ATTN=off \
    IMAGE_MIN_TOKENS=1024 \
    IMAGE_MAX_TOKENS=1024 \
    MTMD_BATCH_MAX_TOKENS=512 \
    GGML_CUDA_DISABLE_GRAPHS=1 \
    CUDA_MODULE_LOADING=LAZY

EXPOSE 8080

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/start-qwen35-4b.sh"]
