FROM linuxserver/openssh-server:latest

# Cài đặt CasaOS
RUN apt update && apt install -y curl && \
    curl -fsSL https://get.casaos.io | bash

# Mở cổng cần thiết
EXPOSE 80 443 8080

CMD ["/usr/bin/tini", "--", "/init"]
