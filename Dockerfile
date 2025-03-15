FROM debian:latest

# Cài đặt các gói cần thiết
RUN apt update && apt install -y curl sudo

# Cài đặt CasaOS
RUN curl -fsSL https://get.casaos.io | bash

EXPOSE 80 443 8080

CMD ["bash"]
