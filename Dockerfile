FROM debian:bullseye-slim

# Cài các tiện ích cần thiết
RUN apt update && \
    apt install -y \
    bash \
    wget \
    curl \
    vim \
    ca-certificates && \
    apt clean

# Tải ttyd bản mới nhất (ví dụ: 1.7.3)
RUN wget -O /tmp/ttyd.tar.gz https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64.tar.gz && \
    tar -xzf /tmp/ttyd.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/ttyd && \
    rm /tmp/ttyd.tar.gz

# Tạo user để chạy ttyd an toàn hơn
RUN useradd -m -s /bin/bash termuser

# Expose port của ttyd
EXPOSE 7681

# Chạy ttyd cho user termuser
CMD ["ttyd", "-p", "7681", "-W", "-t", "title=My Remote Terminal", "-t", "rendererType=webgl", "bash"]
