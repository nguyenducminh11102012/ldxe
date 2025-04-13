# Sử dụng Debian base image
FROM debian:bullseye-slim

# Cập nhật các package cơ bản và cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    lsb-release \
    gnupg2 \
    curl \
    apt-transport-https \
    ca-certificates \
    sudo \
    wget \
    software-properties-common \
    build-essential \
    dpkg-dev \
    git \
    lsof \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Thêm kho Zabbly để cài đặt incus-ui-canonical
RUN curl -fsSL https://packages.zabbly.com/packages.zabbly.com.key | apt-key add - && \
    echo "deb https://packages.zabbly.com/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/zabbly.list

# Cài đặt incus-ui-canonical từ kho Zabbly
RUN apt-get update && apt-get install -y incus-ui-canonical

# Cài đặt Incus
RUN apt-get update && apt-get install -y incus

# Cấu hình Incus để phục vụ Web UI trên cổng 8443
RUN incus config set core.https_address :8443

# Kiểm tra xem Incus đã lắng nghe trên cổng 8443 chưa
RUN lsof -i :8443

# Tạo chứng chỉ người dùng incus-ui.crt và incus-ui.pfx
RUN openssl genpkey -algorithm RSA -out /tmp/incus-ui.key -pkeyopt rsa_keygen_bits:2048 && \
    openssl req -new -key /tmp/incus-ui.key -out /tmp/incus-ui.csr -subj "/C=US/ST=State/L=City/O=Incus/OU=WebUI/CN=incus" && \
    openssl x509 -req -in /tmp/incus-ui.csr -signkey /tmp/incus-ui.key -out /tmp/incus-ui.crt -days 365 && \
    openssl pkcs12 -export -in /tmp/incus-ui.crt -inkey /tmp/incus-ui.key -out /tmp/incus-ui.pfx -passout pass:

# Thêm chứng chỉ người dùng vào Incus
RUN incus config trust add-certificate /tmp/incus-ui.crt

# Kiểm tra lại danh sách các chứng chỉ đã tin cậy trong Incus
RUN incus config trust list

# Xóa các tệp chứng chỉ tạm thời sau khi sử dụng
RUN rm -f /tmp/incus-ui.key /tmp/incus-ui.csr /tmp/incus-ui.crt /tmp/incus-ui.pfx

# Đảm bảo các chứng chỉ SSL của Incus đã được tạo và có sẵn
RUN ls -l /var/lib/incus/server.crt /var/lib/incus/server.key

# Mở cổng 8443 để truy cập Web UI
EXPOSE 8443

# Lệnh khởi động Incus với Web UI
CMD ["incus", "web", "serve", "--listen=0.0.0.0:8443"]
