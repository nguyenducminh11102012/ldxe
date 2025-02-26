# Sử dụng Ubuntu làm base image
FROM ubuntu:latest

# Cập nhật và cài đặt Cockpit
RUN apt update && apt install -y cockpit cockpit-machines podman \
    && apt clean

# Mở cổng 9090
EXPOSE 9090

# Khởi động Cockpit mà không cần systemd
CMD ["/usr/bin/podman", "system", "service", "--time=0"]
