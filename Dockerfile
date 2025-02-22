# Chọn Ubuntu làm base image
FROM ubuntu:latest

# Cập nhật kho và cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    novnc \
    websockify \
    qemu-system-x86 \
    qemu-kvm \
    qemu-utils \
    wget \
    && apt-get clean

# Tạo thư mục để lưu ISO và đĩa ảo
RUN mkdir -p /root/bootcd

# Thiết lập thư mục làm việc
WORKDIR /root/bootcd

# Tải ISO Hiren's BootCD PE x64 từ link bạn cung cấp
RUN wget -O hirensbootcd.iso https://www.hirensbootcd.org/files/HBCD_PE_x64.iso

# Tạo đĩa RAW 40GB
RUN qemu-img create -f raw /root/bootcd/hirens_disk.raw 40G

# Thiết lập cổng 6080 cho websockify và VNC
EXPOSE 6080

# Tạo script khởi động QEMU và websockify
RUN echo '#!/bin/bash\n\
qemu-system-x86_64 \\\n\
    -cpu haswell \\\n\
    -m 1536 \\\n\
    -drive file=/root/bootcd/hirens_disk.raw,format=raw \\\n\
    -cdrom /root/bootcd/hirensbootcd.iso \\\n\
    -boot d \\\n\
    -vnc :0 \\\n\
    -vga std &\n\
websockify --web=/usr/share/novnc/ 6080 localhost:5900\n' > /root/start.sh

# Cấp quyền thực thi cho script
RUN chmod +x /root/start.sh

# Khởi động script khi container bắt đầu
CMD ["/root/start.sh"]
