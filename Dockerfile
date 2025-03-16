FROM ubuntu:latest

# Cập nhật danh sách package và cài đặt curl
RUN apt update && apt install -y curl

# Chạy lệnh cài đặt Tipi
RUN curl -L https://setup.runtipi.io | bash

CMD ["sleep", "infinity"]
