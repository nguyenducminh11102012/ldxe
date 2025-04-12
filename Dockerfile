FROM gentoo/stage3:stage3-amd64-systemd

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Cập nhật hệ thống & cài gói cần thiết
RUN emerge-webrsync && \
    eselect repository enable lxc && \
    emaint sync -r lxc && \
    emerge --sync && \
    emerge --update --deep --newuse @world && \
    emerge --ask=n incus incus-ui sudo dbus

# Tạo user để chạy Incus
RUN useradd -m -G incus incus

# Tạo entrypoint script khởi chạy tự động
RUN mkdir -p /opt/incus-init && \
    cat << 'EOF' > /opt/incus-init/start.sh
#!/bin/bash

# Chuẩn bị môi trường
echo "[*] Initializing Incus..."
incus admin init --minimal || true

echo "[*] Setting REST API on :8080..."
incus config set core.https_address "[::]:8080"

echo "[*] Starting Incus Web UI on :8080..."
exec incus web serve --listen=0.0.0.0:8080
EOF

# Cho phép thực thi
RUN chmod +x /opt/incus-init/start.sh

# Expose port cho Web UI + REST API
EXPOSE 8080

# Dùng systemd và chạy script khi container lên
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init", "--unit=multi-user.target"; "/opt/incus-init/start.sh"]
