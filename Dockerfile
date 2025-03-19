FROM ubuntu:latest

# Cập nhật hệ thống và cài đặt các gói cần thiết
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y \
    qemu-system-x86 \
    novnc websockify \
    wget curl && \
    rm -rf /var/lib/apt/lists/*

# Tạo thư mục làm việc
WORKDIR /root

# Tạo thư mục temp và tải xuống file ISO Tiny10
RUN mkdir -p /tmp && wget -O /tmp/tiny10.iso "https://archive.org/download/tiny-10-NTDEV/Tiny10%20B2.iso"

# Tạo ổ đĩa raw 64GiB
RUN qemu-img create -f raw disk.img 64G

# Mở cổng cần thiết
EXPOSE 8006

# Chạy QEMU trực tiếp khi container khởi động
CMD websockify --web=/usr/share/novnc 8006 localhost:5900 & \
    qemu-system-x86_64 -m 2G -smp 2 -drive file=disk.img,format=raw -cdrom /tmp/tiny10.iso -boot d -vnc :0 -cpu max -accel tcg
