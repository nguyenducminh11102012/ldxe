FROM ubuntu:latest

# Cập nhật hệ thống và cài đặt các gói cần thiết
RUN apt update && apt install -y \
    qemu qemu-system-x86 \
    novnc websockify \
    wget curl && \
    rm -rf /var/lib/apt/lists/*

# Tạo thư mục làm việc
WORKDIR /root

# Tạo thư mục temp và tải xuống file ISO Tiny10
RUN mkdir -p /tmp && wget -O /tmp/tiny10.iso "https://archive.org/download/tiny-10-NTDEV/Tiny10%20B2.iso"

# Tạo ổ đĩa raw 64GiB
RUN qemu-img create -f raw disk.img 64G

# Script để khởi động QEMU với noVNC
RUN echo "#!/bin/bash\n\n" \
         "websockify --web=/usr/share/novnc 8006 localhost:5900 &\n" \
         "qemu-system-x86_64 -m 2G -smp 2 -drive file=disk.img,format=raw -cdrom /tmp/tiny10.iso -boot d -vnc :0 -cpu qemu -accel tcg" > start.sh && \
    chmod +x start.sh

# Mở cổng cần thiết
EXPOSE 8006

# Chạy script khởi động
CMD ["/bin/bash", "-c", "./start.sh"]
