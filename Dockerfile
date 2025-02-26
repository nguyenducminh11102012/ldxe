# Sử dụng hình ảnh Docker của Dockurr cho Windows
FROM dockurr/windows

# Đặt biến môi trường để chọn Windows Server 2012 và vô hiệu hóa KVM
ENV VERSION="2012"
ENV KVM="N"

# Cấp quyền cho container
CAPS NET_ADMIN

# Mở các cổng cần thiết
EXPOSE 8006 3389

# Chạy Windows Server khi container khởi động
CMD ["-it", "--rm", "-p", "8006:8006", "--device=/dev/net/tun", "--cap-add", "NET_ADMIN", "--stop-timeout", "120"]
