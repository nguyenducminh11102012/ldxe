# Sử dụng image có hỗ trợ DinD
FROM docker:stable-dind

# Cài đặt bất kỳ phụ thuộc nào nếu cần
RUN apk add --no-cache curl

# Thêm lệnh để chạy Umbrel bằng docker run
CMD ["docker", "run", "-it", "--rm", "--name", "umbrel", "--pid=host", "-p", "80:80", "-v", "${PWD:-.}/umbrel:/data", "-v", "/var/run/docker.sock:/var/run/docker.sock", "--stop-timeout", "60", "dockurr/umbrel"]
