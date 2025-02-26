# Sử dụng Portainer làm base image
FROM portainer/portainer-ce:latest

# Chạy Portainer với lệnh chính xác
ENTRYPOINT ["/portainer"]
CMD ["--no-auth", "--http-enabled", "--http-bind", "0.0.0.0:9000"]
