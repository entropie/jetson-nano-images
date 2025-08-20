FROM dustynv/l4t-pytorch:r36.4.0

# Tools + curl + libcurl-dev (ggml curl support)
RUN apt-get update && apt-get install -y --no-install-recommends \
      git cmake build-essential pkg-config ca-certificates curl libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# HF CLI (für gezieltes Datei-Download)
RUN pip3 install -U --no-cache-dir \
  --index-url https://pypi.org/simple \
  --extra-index-url https://pypi.ngc.nvidia.com \
  "huggingface_hub[cli]" pillow

# ---- llama.cpp (HEAD) mit CUDA bauen ----
ARG LLAMA_REF=master
RUN git clone https://github.com/ggerganov/llama.cpp /opt/llama.cpp && \
    cd /opt/llama.cpp && git checkout ${LLAMA_REF} && \
    cmake -S . -B build \
      -DGGML_CUDA=ON \
      -DGGML_CUDA_NO_VMM=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CUDA_ARCHITECTURES=87 && \
    cmake --build build -j"$(nproc)" && \
    install -m0755 build/bin/* /usr/local/bin/

# Startscript
COPY start-gemma34b.sh /usr/local/bin/start-gemma34b.sh
RUN chmod +x /usr/local/bin/start-gemma34b.sh

# Defaults + konservative CUDA-Settings (bei Bedarf anpassen)
ENV DATA_DIR=/data/models \
    MODEL_REPO=bartowski/google_gemma-3-4b-it-GGUF \
    MODEL_FILE=gemma-3-4b-it-Q5_K_M.gguf \
    MMPROJ_FILE=mmproj-gemma-3-4b-it-f16.gguf \
    HOST=0.0.0.0 PORT=8080 CTX=1024 NGL=999 THREADS=6 \
    GGML_CUDA_FORCE_CUBLAS=1 \
    GGML_CUDA_DISABLE_GRAPHS=1

EXPOSE 8080
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/start-gemma34b.sh"]
