# Sử dụng Ubuntu làm base image
FROM ubuntu:latest

# Cập nhật và cài đặt Cockpit
RUN apt update && apt install -y cockpit cockpit-machines \
    && apt clean

# Mở cổng 9090 cho Cockpit
EXPOSE 9090

# Chạy Cockpit theo cách thủ công mà không cần systemd
CMD ["/usr/libexec/cockpit-ws", "--no-tls", "--port=9090"]
