FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt các gói cần thiết + ttyd từ release chính thức
RUN apt update && apt install -y \
    curl \
    ca-certificates \
    bash \
    && curl -L https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -o /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

# Expose port 8080
EXPOSE 8080

# Mặc định chạy bash trong ttyd
CMD ["ttyd", "-p", "8080", "--", "bash", "-W"]

