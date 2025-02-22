FROM ubuntu:latest

# Cài đặt ttyd, bash và curl
RUN apt-get update && \
    apt-get install -y ttyd bash curl && \
    apt-get clean

# Cấu hình quyền ghi cho thư mục container (root)
RUN chmod -R 777 /root

# Mở cổng web cho ttyd
EXPOSE 7681

# Chạy ttyd với --writable để có thể ghi vào terminal trên web
CMD ["ttyd", "--writable", "-p", "7681", "bash"]
