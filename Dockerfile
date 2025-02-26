# Sử dụng Ubuntu làm base image
FROM ubuntu:latest

# Cập nhật và cài đặt Cockpit
RUN apt update && apt install -y cockpit cockpit-machines \
    && apt clean

# Mở cổng 9090 cho Cockpit
EXPOSE 9090

# Chạy Cockpit khi container khởi động
CMD ["/usr/libexec/cockpit-ws"]
