# Sử dụng Alpine Linux nhẹ
FROM alpine:latest

# Cài đặt các gói cần thiết
RUN apk add --no-cache ttyd bash

# Đặt cổng mặc định cho ttyd
EXPOSE 6080

# Lệnh chạy ttyd trên cổng 6080 với shell bash
CMD ["ttyd", "-p", "6080", "bash"]
