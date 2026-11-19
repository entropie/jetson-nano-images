FROM captnspdr/wyoming-whisper-trt:latest-igpu

ENV NVIDIA_EMBEDDED=true \
    MODEL=base \
    LANGUAGE=de \
    COMPUTE_TYPE=float16 \
    DECODER_MODE=simple \
    DATA_DIR=/data \
    URI=tcp://0.0.0.0:10300
