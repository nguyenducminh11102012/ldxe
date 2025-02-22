FROM ubuntu:latest

# Cài đặt ttyd và bash
RUN apt-get update && \
    apt-get install -y ttyd bash && \
    apt-get clean

# Mở cổng web cho ttyd
EXPOSE 7681

# Chạy ttyd để hiển thị terminal trên web
CMD ["ttyd", "-p", "7681", "bash"]
