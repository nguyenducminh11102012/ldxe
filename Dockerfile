FROM ubuntu:latest

# Tạo thư mục làm việc
WORKDIR /root

# Cập nhật hệ thống và cài đặt websockify và novnc trước để Render detect cổng nhanh
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y \
    novnc websockify && \
    rm -rf /var/lib/apt/lists/*

# Chạy websockify trước để Render phát hiện port ngay
CMD websockify --web=/usr/share/novnc 8006 localhost:5900 & \
    sleep 2 && \
    apt update && apt install -y qemu-system-x86 wget curl && \
    rm -rf /var/lib/apt/lists/* && \
    wget -O /root/tiny10.iso "https://archive.org/download/tiny-10-NTDEV/Tiny10%20B2.iso" && \
    qemu-img create -f raw /root/disk.img 64G && \
    qemu-system-x86_64 -m 2G -smp 2 -drive file=/root/disk.img,format=raw -cdrom /root/tiny10.iso -boot d -vnc :0 -cpu max -accel tcg
