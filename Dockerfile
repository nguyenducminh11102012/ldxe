FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Cài các công cụ cần thiết
RUN apt-get update && apt-get install -y \
    incus \
    incus-ui-canonical \
    lsof \
    openssl \
    curl \
    sudo \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Khởi tạo cấu hình mặc định cho Incus (nếu chưa có)
RUN incus config set core.https_address :8443

# Kiểm tra Incus đã lắng nghe trên cổng 8443
RUN lsof -i :8443 || echo "Incus chưa khởi động, sẽ kiểm tra sau"

# Tạo user certificate incus-ui.crt và private key
RUN openssl genpkey -algorithm RSA -out /root/incus-ui.key -pkeyopt rsa_keygen_bits:2048 && \
    openssl req -new -key /root/incus-ui.key -out /root/incus-ui.csr -subj "/CN=incus-ui" && \
    openssl x509 -req -in /root/incus-ui.csr -signkey /root/incus-ui.key -out /root/incus-ui.crt -days 365

# Tạo file PFX để import vào trình duyệt (không có mật khẩu)
RUN openssl pkcs12 -export -out /root/incus-ui.pfx \
    -inkey /root/incus-ui.key \
    -in /root/incus-ui.crt \
    -passout pass:

# Thêm chứng chỉ người dùng vào danh sách trust của Incus
RUN incus config trust add-certificate /root/incus-ui.crt

# Xác minh chứng chỉ đã được thêm
RUN incus config trust list

# In thông tin chứng chỉ server tự động của Incus (self-signed)
RUN ls -l /var/lib/incus/server.crt /var/lib/incus/server.key && \
    openssl x509 -in /var/lib/incus/server.crt -noout -text

# Mở cổng 8443
EXPOSE 8443

# Lệnh mặc định khi container khởi động (chạy Incus foreground)
CMD ["incusd", "--foreground"]
