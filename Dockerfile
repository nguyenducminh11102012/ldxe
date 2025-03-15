FROM casaos/casaos:latest

# Đặt biến môi trường nếu cần thiết
ENV CASAOS_URL=http://localhost:80
ENV CASAOS_DEBUG=true

# Chạy CasaOS
CMD ["/usr/bin/casaos"]
