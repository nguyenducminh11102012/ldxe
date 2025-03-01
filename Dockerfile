FROM ubuntu:18.04

# Cập nhật và cài đặt các gói cần thiết
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
    qemu-kvm libvirt-daemon-system libvirt-dev curl unzip wget \
    keyboard-configuration


# Dọn dẹp hệ thống
RUN apt-get autoclean && apt-get autoremove

# Cài đặt ngrok
RUN curl -O https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip \
    && unzip ngrok-v3-stable-linux-amd64.zip \
    && mv ngrok /usr/local/bin/ \
    && chmod +x /usr/local/bin/ngrok

# Thiết lập ngrok authtoken trực tiếp
RUN ngrok authtoken 2nyiyWrhpT6OwyUoaoZ2zdE9nNo_7KtHBQxaox3Wx2t9qBHTT

# Cấu hình Vagrant với libvirt
RUN vagrant plugin install vagrant-libvirt
RUN vagrant box add --provider libvirt peru/windows-10-enterprise-x64-eval
RUN vagrant init peru/windows-10-enterprise-x64-eval

# Expose cổng 3389 để dùng Remote Desktop
EXPOSE 3389

# Sao chép file startup.sh vào container
COPY startup.sh /

# Đảm bảo file startup.sh có quyền thực thi
RUN chmod +x /startup.sh

# Chạy script khởi động
ENTRYPOINT ["/startup.sh"]
