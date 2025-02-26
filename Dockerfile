# Sử dụng Dockurr Windows làm base image
FROM dockurr/windows

# Thiết lập biến môi trường để chạy Windows Server 2012 mà không cần KVM
ENV VERSION="2012"
ENV KVM="N"

# Cấp quyền cần thiết cho container
RUN apt-get update && apt-get install -y iproute2

# Mở cổng dịch vụ
EXPOSE 8006 3389

# Chạy lệnh khởi động Windows Server 2012
CMD ["qemu-system-x86_64", "-m", "4G", "-smp", "2", "-netdev", "user,id=n1", "-device", "e1000,netdev=n1"]
