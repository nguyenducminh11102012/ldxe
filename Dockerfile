# Sử dụng Alpine Linux cho nhẹ
FROM alpine:latest  

# Cài đặt các công cụ cần thiết
RUN apk add --no-cache docker-cli curl

# Tải và cài đặt Portainer
RUN curl -L https://downloads.portainer.io/ce2-18/portainer-2.18.4-linux-amd64.tar.gz | tar -xz \
    && mv portainer /usr/local/bin/

# Mở cổng 9000 cho giao diện web Portainer
EXPOSE 9000  

# Chạy Portainer khi container khởi động
CMD ["portainer", "--host", "unix:///var/run/docker.sock"]
