# Sử dụng Ubuntu 20.04 làm base image
FROM ubuntu:20.04

# Đặt biến môi trường để bỏ qua các prompt khi cài gói
ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài các gói cần thiết
RUN apt update && \
    apt install -y \
    git \
    cmake \
    g++ \
    libjson-c-dev \
    libwebsockets-dev \
    libssl-dev \
    libuv1-dev \
    build-essential \
    wget \
    curl \
    vim \
    pkg-config \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Clone ttyd từ GitHub và build
RUN git clone https://github.com/tsl0922/ttyd.git /ttyd && \
    cd /ttyd && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# Expose port 8080
EXPOSE 8080

# Lệnh mặc định: chạy ttyd với shell bash
CMD ["ttyd", "-p",, "-W", "8080", "bash"]
