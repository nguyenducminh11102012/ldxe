FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Cài qemu + novnc + websockify
RUN apt update && apt install -y \
    qemu-system-x86 \
    wget \
    git \
    python3 \
    python3-websockify \
    && apt clean

WORKDIR /root

# Tải ISO
RUN wget -O windows.iso "https://archive.org/download/windows-server-2025-beta-build-25295-lite-os-tiny-server-11/Windows%20Server%202025%20Beta%20Build%2025295%20-%20LiteOS%20%23TinyServer11.iso"

# Clone noVNC + websockify
RUN git clone https://github.com/novnc/noVNC.git && \
    git clone https://github.com/novnc/websockify noVNC/utils/websockify

# Tạo ổ cứng ảo
RUN qemu-img create -f qcow2 disk.qcow2 60G

# Mở port
EXPOSE 6080 3389

# CMD tối ưu CPU Broadwell
CMD qemu-system-x86_64 \
    -m 1024 \
    -cpu Broadwell,+sse4.1,+sse4.2,+aes,+avx,+avx2,+xsave,+xsaveopt,+smep,+fma,+movbe,+xsavec,+xgetbv1 \
    -smp 2 \
    -machine type=q35,accel=tcg \
    -vga std \
    -device virtio-balloon-pci \
    -netdev user,id=net0,hostfwd=tcp::3389-:3389 \
    -device e1000,netdev=net0 \
    -drive file=/root/disk.qcow2,format=qcow2,aio=native,cache=none,discard=on \
    -drive file=/root/windows.iso,media=cdrom,index=2 \
    -vnc :3 \
    -usb -device usb-tablet & \
    /root/noVNC/utils/novnc_proxy --vnc localhost:5903 --listen 6080
