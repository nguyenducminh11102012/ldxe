FROM ubuntu:latest

# Cập nhật và cài đặt NoVNC và Websockify
RUN apt update && apt install -y \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

# Lệnh CMD khởi chạy Websockify trước
CMD websockify --web=/usr/share/novnc/ 8006 localhost:5900 & \
    (apt update && apt install -y qemu-system-x86 wget && rm -rf /var/lib/apt/lists/*) && \
    wget -O /iso/Updated_Win10PE_x64.iso \
    https://archive.org/download/updated-win-10-pe-x-64/Updated_Win10PE_x64.iso && \
    qemu-system-x86_64 \
    -m 512 \
    -smp $(nproc) \
    -drive file=/iso/Updated_Win10PE_x64.iso,index=0,media=cdrom \
    -hda /tmp/disk.img \
    -net none \
    -no-kvm \
    -vnc :0 & \
    (dd if=/dev/zero of=/tmp/disk.img bs=1M count=32768 && \
    while true; do echo "hello"; sleep 1; done)
