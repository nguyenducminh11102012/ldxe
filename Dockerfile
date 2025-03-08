FROM ubuntu:latest

# Cập nhật hệ thống và cài đặt các dependencies cần thiết
RUN apt update && apt install -y curl sudo && rm -rf /var/lib/apt/lists/*

# Chạy lệnh cài đặt Coolify
RUN curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

# Mở các cổng cần thiết
EXPOSE 3000 80 443

# Lệnh khởi động container
CMD ["/bin/bash"]
