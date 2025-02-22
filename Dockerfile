# Chọn Ubuntu làm base image
FROM ubuntu:latest

# Cài đặt các gói cần thiết và đảm bảo kho chứa của Ubuntu có sẵn
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:jacob/virtualization \
    && apt-get update \
    && apt-get install -y \
    qemu-system-x86 \
    novnc \
    websockify \
    wget \
    && apt-get clean

# Tạo thư mục để lưu ISO và đĩa ảo
RUN mkdir -p /root/windows_install

# Thiết lập thư mục làm việc
WORKDIR /root/windows_install

# Tải Windows ISO từ link bạn cung cấp
RUN wget -O windows.iso https://go.microsoft.com/fwlink/p/?LinkID=2195443&clcid=0x409&culture=en-us&country=US

# Tạo đĩa RAW 40GB
RUN qemu-img create -f raw /root/windows_install/windows_disk.raw 40G

# Thiết lập cổng 6080 cho websockify và VNC
EXPOSE 6080

# Cài đặt script khởi động QEMU và websockify
RUN echo '#!/bin/bash\n\
qemu-system-x86_64 \\\n\
    -cpu haswell \\\n\
    -m 1024 \\\n\
    -drive file=/root/windows_install/windows_disk.raw,format=raw \\\n\
    -cdrom /root/windows_install/windows.iso \\\n\
    -boot d \\\n\
    -vnc :0 \\\n\
    -vga std &\n\
websockify --web=/usr/share/novnc/ 6080 localhost:5900\n' > /root/start.sh

# Cấp quyền thực thi cho script
RUN chmod +x /root/start.sh

# Khởi động script khi container bắt đầu
CMD ["/root/start.sh"]
