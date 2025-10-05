# Single-Stage Build: Baut llama.cpp und richtet die Laufzeitumgebung in einem Schritt ein.
FROM dustynv/l4t-pytorch:r36.4.0

# 1. Installiert die zum Kompilieren und Ausführen benötigten Systempakete
RUN apt-get update && apt-get install -y --no-install-recommends \
    git cmake build-essential pkg-config ca-certificates curl libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Installiert die Python-Pakete (für das hf-cli-Tool)
RUN pip3 install -U --no-cache-dir \
  --index-url https://pypi.org/simple \
  --extra-index-url https://pypi.ngc.nvidia.com \
  "huggingface_hub[cli]" pillow

# 3. Klont und kompiliert llama.cpp mit CUDA-Unterstützung
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

# 4. Richtet das generische Startskript ein
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 5. Setzt minimale Umgebungsvariablen als Fallback
ENV DATA_DIR=/data/models \
    HOST=0.0.0.0 \
    PORT=8080

# 6. Definiert den Startpunkt des Containers
EXPOSE 8080
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
