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
RUN git clone https://github.com/osamuaoki/incus-ui-canonical && \
    cd incus-ui-canonical && \
    git remote add canonical https://github.com/canonical/lxd-ui && \
    git remote update

# Tạo tarball từ mã nguồn Incus UI
RUN cd incus-ui-canonical && \
    git archive --prefix=incus-ui-canonical-0.6/ --format=tar.gz -o ../incus-ui-canonical_0.6.orig.tar.gz incus-ui-canonical/0.6

# Checkout branch debian và build gói .deb
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
