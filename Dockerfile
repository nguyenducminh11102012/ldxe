# Sử dụng hình ảnh Dockurr cho Windows
FROM dockurr/windows

# Đặt biến môi trường để chọn Windows Server 2012 và vô hiệu hóa KVM
ENV VERSION="2012"
ENV KVM="N"

# Cấp quyền NET_ADMIN
RUN setcap CAP_NET_ADMIN+ep /usr/bin/qemu-system-x86_64

# Mở cổng cần thiết
EXPOSE 8006 3389

# Chạy Windows với thông số đúng, tránh lỗi tini
CMD ["qemu-system-x86_64", "-m", "4G", "-smp", "2", "-netdev", "user,id=n1", "-device", "e1000,netdev=n1"]
