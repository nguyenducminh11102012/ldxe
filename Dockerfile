FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    ANDROID_HOME=/home/developer/Android/Sdk \
    PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools \
    VNC_PORT=5901 \
    NOVNC_PORT=6080

# Cài đặt các gói cần thiết (bao gồm cả tigervnc-common)
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    wget \
    curl \
    git \
    unzip \
    x11vnc \
    xvfb \
    openbox \
    sudo \
    novnc \
    websockify \
    net-tools \
    tigervnc-standalone-server \
    tigervnc-common \
    tigervnc-xorg-extension \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Tạo user developer
RUN useradd -m developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Cài đặt Android Studio (sửa lỗi chính tả thư mục)
RUN mkdir -p /opt/android-studio && \
    wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.24/android-studio-2023.1.1.24-linux.tar.gz -O studio.tar.gz && \
    tar -xzf studio.tar.gz -C /opt/android-studio --strip-components=1 && \
    rm studio.tar.gz

# Cấu hình VNC (sử dụng x11vnc thay vì vncpasswd)
RUN mkdir -p /home/developer/.vnc && \
    echo "password" > /home/developer/.vnc/passwd && \
    chown -R developer:developer /home/developer/.vnc && \
    chmod 0600 /home/developer/.vnc/passwd

# Tạo script khởi động tích hợp
RUN echo '#!/bin/bash\n\
# Khởi động Xvfb với các tham số tối ưu\n\
Xvfb :1 -screen 0 1280x800x16 -ac -nolisten tcp +extension GLX +render -noreset >/var/log/Xvfb.log 2>&1 &\n\
sleep 2\n\
\n\
# Khởi động window manager\n\
sudo -u developer openbox-session >/var/log/openbox.log 2>&1 &\n\
\n\
# Khởi động Android Studio\n\
sudo -u developer /opt/android-studio/bin/studio.sh >/var/log/android-studio.log 2>&1 &\n\
\n\
# Khởi động VNC server (không yêu cầu password)\n\
x11vnc -display :1 -noxdamage -forever -shared -rfbport $VNC_PORT -passwd password -bg -o /var/log/x11vnc.log\n\
\n\
# Khởi động NoVNC với heartbeat\n\
websockify --web=/usr/share/novnc/ $NOVNC_PORT localhost:$VNC_PORT --heartbeat=30\n\
\n\
# Giữ container chạy\n\
tail -f /dev/null' > /start-vnc.sh && \
    chmod +x /start-vnc.sh

# Expose các cổng cần thiết
EXPOSE $VNC_PORT $NOVNC_PORT

# Khởi động bằng script
CMD ["/start-vnc.sh"]
