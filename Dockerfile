FROM debian:bullseye-slim

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    devscripts \
    yarnpkg \
    npm \
    git \
    sudo \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    dpkg-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone repo Incus UI
# Cài đặt Node.js mới và Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Tiếp tục với các bước còn lại
RUN git clone https://github.com/osamuaoki/incus-ui-canonical && \
    cd incus-ui-canonical && \
    git remote add canonical https://github.com/canonical/lxd-ui && \
    git remote update
RUN cd incus-ui-canonical && \
    git checkout debian && \
    debuild -us -uc && \
    cd .. && \
    dpkg -i incus-ui-canonical*.deb


# Cài đặt Incus
RUN apt-get update && apt-get install -y incus

# Cấu hình Incus với API
RUN incus config set core.https_address ":8443"

# Tạo thư mục Web UI của Incus
RUN mkdir -p /var/lib/incus/ui && \
    cp -r /opt/incus-ui-canonical/incus-ui-canonical-0.6/* /var/lib/incus/ui/

# Expose port 8443 cho Web UI
EXPOSE 8443

# Khởi động Incus khi container chạy
CMD ["incus", "web", "serve", "--listen=0.0.0.0:8443"]
