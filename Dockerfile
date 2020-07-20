FROM nvidia/cuda:9.0-base-ubuntu16.04
LABEL maintainer="Timmy Lo <loyangchun@gmail.com>"

ENV MAKEFLAGS "-j4"

ARG DEBIAN_FRONTEND=noninteractive

ENV NCCL_VERSION=2.2.13
ENV CUDNN_VERSION=7.2.1.38

RUN apt-get update && apt-get install -y --no-install-recommends \
    automake \
    build-essential \
    ca-certificates \
    cuda-command-line-tools-9-0 \
    cuda-cublas-dev-9-0 \
    cuda-cudart-dev-9-0 \
    cuda-cufft-dev-9-0 \
    cuda-curand-dev-9-0 \
    cuda-cusolver-dev-9-0 \
    cuda-cusparse-dev-9-0 \
    curl \
    git \
    libfreetype6-dev \
    libpng12-dev \
    libtool \
    libcudnn7=${CUDNN_VERSION}-1+cuda9.0 \
    libcudnn7-dev=${CUDNN_VERSION}-1+cuda9.0 \
    libcurl3-dev \
    libnccl2=${NCCL_VERSION}-1+cuda9.0 \
    libnccl-dev=${NCCL_VERSION}-1+cuda9.0 \
    libzmq3-dev \
    mlocate \
    openjdk-8-jdk\
    openjdk-8-jre-headless \
    pkg-config \
    python-dev \
    software-properties-common \
    swig \
    unzip \
    wget \
    zip \
    zlib1g-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    find /usr/local/cuda-9.0/lib64/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete && \
    rm /usr/lib/x86_64-linux-gnu/libcudnn_static_v7.a

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN apt-get -y update
RUN apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    python3-dev \
    python3-numpy \
    python3-setuptools \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN cd ~ && \
    mkdir -p dlib && \
    git clone https://github.com/davisking/dlib.git dlib/ && \
    cd ./dlib && \
    git checkout 579a41d5 && \
    mkdir build && \
    cd build && \
    cmake .. -DUSE_AVX_INSTRUCTIONS=1 -DDLIB_USE_CUDA=1 && \
    cmake --build . && \
    cd .. && \
    python3 setup.py install && \
    cd ~ && rm -rf dlib

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

RUN pip3 install --upgrade pip

RUN pip3 --no-cache-dir install \
    opencv-python \
    psutil \
    pillow \
    pymongo \
    flask \
    joblib \
    shortuuid \
    requests \
    waitress \
    scikit-image \
    loguru \
    scikit-learn==0.21.3 \
    flask-cors \
    pandas \
    flask-log-request-id \
    pyzmq
    
