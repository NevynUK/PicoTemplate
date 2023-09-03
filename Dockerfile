FROM ubuntu

# The following 2 lines are added to avoid hanging the container creation. 
# See <https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d>
ENV TZ=Europe/Brussels
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    build-essential binutils-dev libelf-dev \
    gcc-arm-none-eabi binutils-arm-none-eabi \
    python3.10 python3-distutils python3-pip python3-apt \
    sed clang-15 cmake git pkg-config libusb-1.0-0-dev

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

CMD ["/bin/bash"]