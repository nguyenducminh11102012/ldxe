FROM dockurr/windows

# Thiết lập biến môi trường
ENV VERSION="2012"
ENV KVM="N"

# Cấp quyền cho container
RUN apt-get update && apt-get install -y iproute2

# Mở cổng 8006
EXPOSE 8006

# Chạy container với quyền NET_ADMIN và mở TUN device
CMD ["sh", "-c", "iptables -t nat -A POSTROUTING -j MASQUERADE && /entrypoint.sh"]
