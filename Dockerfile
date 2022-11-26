FROM ubuntu:22.04

# Config
ENV ZEPHYR_VERSION v3.2.0
ENV ZEPHYR_SDK_VERSION 0.15.1
ENV ZEPHYR_SDK_ARCH linux-x86_64

# End config
ENV PATH="${PATH}:/commands"
ENV DEBIAN_FRONTEND noninteractive

# Steps from here https://docs.zephyrproject.org/latest/develop/getting_started/index.html

RUN apt update && apt install -y --no-install-recommends git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1 git curl

# Zephyr install
RUN mkdir zephyrproject && \
    curl -L https://github.com/zephyrproject-rtos/zephyr/archive/refs/tags/${ZEPHYR_VERSION}.tar.gz -o zephyr.tar.gz && \
    tar xf zephyr.tar.gz -C zephyrproject && rm zephyr.tar.gz

# West project setup
RUN pip install west && \
    west init zephyrproject && \
    cd zephyrproject && \
    west update && \
    west zephyr-export && \
    pip install -r zephyr/scripts/requirements.txt

# Zephyr SDK
RUN curl -L https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.1/zephyr-sdk-${ZEPHYR_SDK_VERSION}_${ZEPHYR_SDK_ARCH}.tar.gz -o sdk.tar.gz && \
    tar xf sdk.tar.gz && \
    rm ../sdk.tar.gz
# Docker is not caching the download
RUN cd zephyr-sdk-${ZEPHYR_SDK_VERSION} && \
    ./setup.sh -h

# Extra commands
ADD commands /commands
RUN chmod +x /commands/*

ENTRYPOINT ["/bin/bash"]
CMD ["/bin/bash"]