# Sử dụng image có hỗ trợ DinD
FROM docker:stable-dind

# Cài đặt curl
RUN apk add --no-cache curl

# Khởi động Docker daemon trước khi cài Tipi
RUN dockerd & sleep 5 && \
    curl -L https://setup.runtipi.io | bash

# Mở cổng cho Tipi
EXPOSE 80 443 8080

# Chạy Docker daemon và giữ container chạy
CMD ["dockerd"]
