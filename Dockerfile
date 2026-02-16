## Run with: docker build -o . . 

FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y \
    cmake build-essential wget python3-pip ninja-build git

RUN wget -qO /usr/share/keyrings/cuda-archive-keyring.gpg \
    https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/ /" \
    > /etc/apt/sources.list.d/cuda.list \
    && apt update \
    && apt install -y --no-install-recommends \
    cuda-toolkit-12-8 libcudnn9-cuda-12 libcudnn9-dev-cuda-12 libnccl2 libnccl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/local/cuda-12.8 /usr/local/cuda || true

WORKDIR /build

ENV PATH="$PATH:/usr/local/cuda-12.8/bin"

RUN git clone https://github.com/Danukeru/torv3_vanity_addr_cuda t3vac && \
    cd t3vac && \
    pip install --break-system-packages -r util/requirements.txt && \
    mkdir build && cd build && \
    cmake .. -G Ninja && \
    ninja

RUN tar zcvf t3vac.tar.gz t3vac

FROM scratch
COPY --from=builder /build/t3vac.tar.gz /
