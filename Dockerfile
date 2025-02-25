FROM ubuntu:22.04

# Bỏ câu hỏi khi cài đặt
ENV DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt QEMU, noVNC
RUN apt update && apt install -y \
    qemu-system-x86 \
    wget \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

# Tải Ubuntu ISO
WORKDIR /root
RUN wget -O ubuntu.iso https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso

# Tạo ổ đĩa RAW 40GB
RUN dd if=/dev/zero of=/root/ubuntu.img bs=1M count=40960

# Script khởi động QEMU + noVNC
RUN echo '#!/bin/bash\n\
qemu-system-x86_64 -cpu qemu64 -smp 4 -m 2048 \n\
-drive file=/root/ubuntu.img,format=raw \n\
-boot d -cdrom ubuntu.iso -vnc :0 &\n\
websockify --web=/usr/share/novnc 6080 localhost:5900' > /root/start.sh \
    && chmod +x /root/start.sh

# Expose cổng noVNC
EXPOSE 6080

# Chạy QEMU + noVNC khi container khởi động
CMD ["/bin/bash", "/root/start.sh"]
