FROM dockurr/casa

# Thiết lập thư mục làm việc (tùy chỉnh nếu cần)
WORKDIR /DATA

# Mount Docker socket để CasaOS có thể quản lý container
VOLUME ["/DATA", "/var/run/docker.sock"]

# Mở cổng 8080 để truy cập CasaOS
EXPOSE 8080

# Định nghĩa thời gian chờ khi dừng container
STOPSIGNAL SIGTERM

# Chạy CasaOS
CMD ["/usr/bin/casaos"]
