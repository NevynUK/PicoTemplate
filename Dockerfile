#
#   Sections of this file are original, some is taken from the cproject repository:
#
#   https://github.com/lmapii/cproject
#
#   with further discussion at:
#
#   https://interrupt.memfault.com/blog/a-modern-c-dev-env
#
FROM --platform=linux/amd64 ubuntu AS pico-builder

#
#   The following 2 lines are added to avoid hanging the container creation. 
#   See <https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d>
#
ENV TZ=Europe/Brussels
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update --fix-missing \
        && apt-get -y upgrade \
        && apt-get install -y --no-install-recommends \
        curl \
        cmake \
        build-essential \
        gcc \
        g++-multilib \
        locales \
        make \
        ruby \
        gcovr \
        wget \
        binutils-dev \
        libelf-dev \
        gcc-arm-none-eabi \
        libnewlib-arm-none-eabi \
        libstdc++-arm-none-eabi-newlib \
        binutils-arm-none-eabi \
        python3.10 \
        python3-distutils \
        python3-pip \
        python3-apt \
        sed \
        git \
        pkg-config \
        libusb-1.0-0-dev \
        valgrind \
        && rm -rf /var/lib/apt/lists/*

################################################################################
#
#   Sort out LLVM / Clang.
#
ARG llvm_version=15

RUN apt-get install -y --no-install-recommends \
        clang-format-${llvm_version} \
        clang-tidy-${llvm_version} \
        clang-${llvm_version}

RUN ln -s /usr/bin/clang-${llvm_version} /usr/local/bin/clang
RUN ln -s /usr/bin/clang-format-${llvm_version} /usr/local/bin/clang-format
RUN ln -s /usr/bin/clang-tidy-${llvm_version} /usr/local/bin/clang-tidy

################################################################################
#
#   Install pre-built clang wrappers
#
RUN mkdir -p /usr/local/run-clang-format
RUN wget -O clang-utils.tgz "https://github.com/lmapii/run-clang-format/releases/download/v1.4.10/run-clang-format-v1.4.10-i686-unknown-linux-gnu.tar.gz" && \
    tar -C /usr/local/run-clang-format -xzf clang-utils.tgz --strip-components 1 && \
    rm clang-utils.tgz
ENV PATH /usr/local/run-clang-format:$PATH
RUN run-clang-format --version

RUN mkdir -p /usr/local/run-clang-tidy
RUN wget -O clang-utils.tgz "https://github.com/lmapii/run-clang-tidy/releases/download/v0.2.1/run-clang-tidy-v0.2.1-i686-unknown-linux-gnu.tar.gz" && \
    tar -C /usr/local/run-clang-tidy -xzf clang-utils.tgz --strip-components 1 && \
    rm clang-utils.tgz
ENV PATH /usr/local/run-clang-tidy:$PATH
RUN run-clang-format --version

################################################################################
#
#   Now for the Pico SDK and tools.
#
ARG SDK_PATH=/usr/share/pico-sdk
RUN git clone -b master https://github.com/raspberrypi/pico-sdk.git $SDK_PATH && \
    cd $SDK_PATH && \
    git submodule update --init

ENV PICO_SDK_PATH=$SDK_PATH

RUN git clone https://github.com/raspberrypi/picotool.git --branch master /home/picotool && \
    cd /home/picotool && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    cp /home/picotool/build/picotool /usr/bin/picotool && \
    rm -rf /home/picotool

RUN ln -s /usr/bin/sed /usr/local/bin/gsed \
        && ln -s /usr/bin/python3 /usr/bin/python

################################################################################
#
#   Install unity and ceedling
#
RUN gem install ceedling
ENV RUBYOPT "-KU -E utf-8:utf-8"

################################################################################
#
#   Cleanup and vulnerability fixes
#
RUN apt remove -y \
    wget

CMD ["/bin/bash"]