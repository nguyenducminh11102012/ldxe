# Sử dụng hình ảnh chính thức của Portainer
FROM portainer/portainer-ce:latest  

# Chạy Portainer mà không cần Docker daemon
CMD ["/portainer", "--no-auth", "--bind", "0.0.0.0:9000"]
