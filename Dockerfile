FROM pufferpanel/pufferpanel:latest

# Tạo thư mục dữ liệu
RUN mkdir -p /var/lib/pufferpanel

# Tạo volume (cái này thường được tạo bên ngoài Dockerfile)
# VOLUME /etc/pufferpanel
# VOLUME /var/lib/pufferpanel

# Expose các cổng
EXPOSE 8080
EXPOSE 5657

# Tạo người dùng root với mật khẩu "Binhminh12"
RUN /pufferpanel/pufferpanel user add root --password Binhminh12

# Khởi động pufferpanel
CMD ["/pufferpanel/pufferpanel"]
