FROM ubuntu:22.04

# Cập nhật và cài đặt QEMU, noVNC
RUN apt update && apt install -y \
    qemu-system-x86 \
    qemu-utils \
    wget \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

# Tải Ubuntu ISO
WORKDIR /root
RUN wget -O ubuntu.iso https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso

# Script khởi động QEMU + noVNC
RUN echo '#!/bin/bash\n\
qemu-system-x86_64 -cpu qemu64 -m 2048 -cdrom ubuntu.iso -boot d -vnc :0 &\n\
websockify --web=/usr/share/novnc 6080 localhost:5900' > /root/start.sh \
    && chmod +x /root/start.sh

# Expose cổng noVNC
EXPOSE 6080

# Chạy QEMU + noVNC khi container khởi động
CMD ["/bin/bash", "/root/start.sh"]
