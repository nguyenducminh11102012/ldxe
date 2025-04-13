FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Cài công cụ cần thiết
RUN apt-get update && apt-get install -y \
    gnupg curl wget lsb-release sudo iproute2 openssl lsof

# Tạo thư mục keyring
RUN mkdir -p /etc/apt/keyrings

# Tải khóa Zabbly
RUN curl -fsSL https://pkgs.zabbly.com/key.asc -o /etc/apt/keyrings/zabbly.asc

# Thêm kho Zabbly (stable)
RUN echo "Enabled: yes" > /etc/apt/sources.list.d/zabbly-incus-stable.sources && \
    echo "Types: deb" >> /etc/apt/sources.list.d/zabbly-incus-stable.sources && \
    echo "URIs: https://pkgs.zabbly.com/incus/stable" >> /etc/apt/sources.list.d/zabbly-incus-stable.sources && \
    echo "Suites: bullseye" >> /etc/apt/sources.list.d/zabbly-incus-stable.sources && \
    echo "Components: main" >> /etc/apt/sources.list.d/zabbly-incus-stable.sources && \
    echo "Architectures: amd64" >> /etc/apt/sources.list.d/zabbly-incus-stable.sources && \
    echo "Signed-By: /etc/apt/keyrings/zabbly.asc" >> /etc/apt/sources.list.d/zabbly-incus-stable.sources

# Cập nhật APT và cài Incus + Web UI
RUN apt-get update && apt-get install -y \
    incus incus-ui-canonical && \
    rm -rf /var/lib/apt/lists/*

# Mở port 8443 cho Incus (UI)
RUN incus config set core.https_address :8443

# Tạo certificate cho trình duyệt (user cert)
RUN mkdir -p /certs && \
    openssl req -x509 -newkey rsa:4096 -nodes \
    -keyout /certs/incus-ui.key -out /certs/incus-ui.crt \
    -days 3650 -subj "/CN=incus-ui" && \
    openssl pkcs12 -export \
    -inkey /certs/incus-ui.key \
    -in /certs/incus-ui.crt \
    -out /certs/incus-ui.pfx \
    -passout pass: && \
    incus config trust add-certificate /certs/incus-ui.crt

# Expose UI port
EXPOSE 8443

# Start Incus (sử dụng CMD để giữ container sống)
CMD [ "sleep", "infinity" ]
