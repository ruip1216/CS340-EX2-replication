FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    clang-18 \
    wget \
    unzip \
    time \
    bc \
    && ln -sf /usr/bin/clang-18 /usr/bin/clang \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app/

RUN chmod +x *.sh scripts/*.sh 2>/dev/null || true

CMD ["/bin/bash"]
