# Sử dụng Docker image cho Docker-in-Docker
FROM docker:stable-dind

# Cài đặt curl (nếu cần thiết)
RUN apk add --no-cache curl

# Đảm bảo container chạy ở chế độ non-interactive
CMD ["docker", "run", "--rm", "--name", "umbrel", "--pid=host", "-p", "80:80", "-v", "${PWD:-.}/umbrel:/data", "-v", "/var/run/docker.sock:/var/run/docker.sock", "--stop-timeout", "60", "dockurr/umbrel"]
