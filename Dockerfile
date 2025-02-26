# Sử dụng hình ảnh Dockurr cho Windows
FROM dockurr/windows

# Đặt biến môi trường
ENV VERSION="2012"
ENV KVM="N"

# Mở cổng
EXPOSE 8006 3389

# Sử dụng Tini đúng cách
ENTRYPOINT ["/usr/bin/tini", "--"]

# Chạy lệnh chính xác
CMD ["qemu-system-x86_64", "-m", "4G", "-smp", "2", "-netdev", "user,id=n1", "-device", "e1000,netdev=n1"]
