FROM debian:latest

# Cài đặt công cụ cần thiết
RUN apt update && apt install -y curl sudo util-linux

# Tạo file SWAP (512MB) để tăng bộ nhớ ảo
RUN fallocate -l 512M /swapfile && \
    chmod 600 /swapfile && \
    mkswap /swapfile && \
    swapon /swapfile

# Cài đặt CasaOS
RUN curl -fsSL https://get.casaos.io | bash

EXPOSE 80 443 8080

CMD ["bash"]
