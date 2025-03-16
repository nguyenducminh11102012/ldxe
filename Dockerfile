# Sử dụng image của Umbrel
FROM dockurr/umbrel:latest

# Mở cổng 80 của container
EXPOSE 80

# Mount volume
VOLUME ["/umbrel", "/data", "/var/run/docker.sock"]

# Lệnh khởi động ứng dụng Umbrel
CMD ["./umbrel", "start"]
