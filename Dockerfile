# Sử dụng Ubuntu 20.04 làm base image
FROM ubuntu:20.04

# Đảm bảo không có bất kỳ prompt nào khi cài đặt
ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt các package cần thiết: curl, lxd và các công cụ hỗ trợ khác
RUN apt-get update && \
    apt-get install -y curl lxd && \
    apt-get clean

# Thiết lập LXD và các cấu hình cơ bản
RUN lxc init ubuntu:20.04 lxdmosaic && \
    lxc config set core.https_address [::] && \
    lxc config set core.trust_password admin

# Kết nối vào container và cài đặt LXDMosaic
RUN lxc exec lxdmosaic -- bash -c "curl https://raw.githubusercontent.com/turtle0x1/LxdMosaic/master/examples/install_with_clone.sh -o installLxdMosaic.sh && \
    chmod +x installLxdMosaic.sh && \
    ./installLxdMosaic.sh"

# Mặc định chạy bash khi container khởi động
CMD ["/bin/bash"]
