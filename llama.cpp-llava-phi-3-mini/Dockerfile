FROM dustynv/l4t-pytorch:r36.4.0

# Tools + curl + libcurl-dev (ggml curl support)
RUN apt-get update && apt-get install -y --no-install-recommends \
      git cmake build-essential pkg-config ca-certificates curl libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# (Optional) Py bits; praktisch für hf CLI, aber nicht zwingend
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
COPY start-phi3.sh /usr/local/bin/start-phi3.sh
RUN chmod +x /usr/local/bin/start-phi3.sh

ENV DATA_DIR=/data/models \
    MODEL_REPO=xtuner/llava-phi-3-mini-gguf \
    MODEL_FILE=llava-phi-3-mini-q5_k_m.gguf \
    MMPROJ_FILE=llava-phi-3-mini-mmproj-f16.gguf \
    HOST=0.0.0.0 PORT=8080 CTX=2048 NGL=999 THREADS=6 \
    GGML_CUDA_FORCE_CUBLAS=1 \
    GGML_CUDA_DISABLE_GRAPHS=1

EXPOSE 8080
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/start-phi3.sh"]
