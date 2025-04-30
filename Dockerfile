FROM ubuntu:22.04

# Đặt các biến môi trường (không comment trên cùng dòng)
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
# Độ phân giải thấp để tăng tốc
ENV RESOLUTION=1024x768x16
ENV VNC_PORT=5901
ENV NOVNC_PORT=6080
ENV ANDROID_HOME=/opt/android-sdk

# Cài đặt gói tối thiểu
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    wget \
    xvfb \
    fluxbox \
    x11vnc \
    novnc \
    websockify \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Tạo user developer
RUN useradd -m developer && \
    mkdir -p /home/developer/.vnc && \
    echo "android" | vncpasswd -f > /home/developer/.vnc/passwd && \
    chown -R developer:developer /home/developer/.vnc && \
    chmod 0600 /home/developer/.vnc/passwd

# Cài đặt Android Studio
RUN mkdir -p /opt/android-studio && \
    wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.24/android-studio-2023.1.1.24-linux.tar.gz -O studio.tar.gz && \
    tar -xzf studio.tar.gz -C /opt/android-studio --strip-components=1 && \
    rm studio.tar.gz

# Script khởi động tối ưu tốc độ
RUN echo '#!/bin/bash
# Khởi động Xvfb
Xvfb $DISPLAY -screen 0 $RESOLUTION -ac -nolisten tcp >/dev/null 2>&1 &
sleep 1

# Khởi động fluxbox
fluxbox >/dev/null 2>&1 &

# Khởi động Android Studio
/opt/android-studio/bin/studio.sh >/dev/null 2>&1 &

# Khởi động x11vnc với các tham số tối ưu
x11vnc -display $DISPLAY -forever -shared -rfbport $VNC_PORT \
       -passwd $(cat /home/developer/.vnc/passwd) -bg \
       -noxdamage -xrandr -threads -nowf -nopw -wait 5 -defer 5 \
       -permitfiletransfer -tightfilexfer >/dev/null 2>&1

# Khởi động NoVNC
websockify --web=/usr/share/novnc/ $NOVNC_PORT localhost:$VNC_PORT \
           --heartbeat=25 --timeout=30 >/dev/null 2>&1

# Giữ container chạy
tail -f /dev/null' > /start.sh && \
    chmod +x /start.sh

EXPOSE $VNC_PORT $NOVNC_PORT

USER developer
WORKDIR /home/developer
CMD ["/start.sh"]
