FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    RESOLUTION=1024x768x16 \  # Độ phân giải thấp để tăng tốc
    VNC_PORT=5901 \
    NOVNC_PORT=6080 \
    ANDROID_HOME=/opt/android-sdk

# Cài đặt gói tối thiểu
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    wget \
    xvfb \
    fluxbox \  # Window manager nhẹ nhất
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

# Cài đặt Android Studio (bản nhẹ nhất)
RUN mkdir -p /opt/android-studio && \
    wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.24/android-studio-2023.1.1.24-linux.tar.gz -O studio.tar.gz && \
    tar -xzf studio.tar.gz -C /opt/android-studio --strip-components=1 && \
    rm studio.tar.gz

# Script khởi động tối ưu tốc độ
RUN echo '#!/bin/bash\n\
# Khởi động Xvfb với tham số tối ưu\n\
Xvfb $DISPLAY -screen 0 $RESOLUTION -ac -nolisten tcp >/dev/null 2>&1 &\n\
sleep 1\n\
\n\
# Khởi động fluxbox (không cần log)\n\
fluxbox >/dev/null 2>&1 &\n\
\n\
# Khởi động Android Studio\n\
/opt/android-studio/bin/studio.sh >/dev/null 2>&1 &\n\
\n\
# Khởi động x11vnc với tham số tối ưu tốc độ\n\
x11vnc -display $DISPLAY -forever -shared -rfbport $VNC_PORT \
       -passwd $(cat /home/developer/.vnc/passwd) -bg \
       -noxdamage -xrandr -threads -nowf -nopw -wait 5 -defer 5 \
       -permitfiletransfer -tightfilexfer >/dev/null 2>&1\n\
\n\
# Khởi động NoVNC với buffer lớn\n\
websockify --web=/usr/share/novnc/ $NOVNC_PORT localhost:$VNC_PORT \
           --heartbeat=25 --timeout=30 >/dev/null 2>&1\n\
\n\
# Giữ container chạy\n\
tail -f /dev/null' > /start.sh && \
    chmod +x /start.sh

EXPOSE $VNC_PORT $NOVNC_PORT

USER developer
WORKDIR /home/developer
CMD ["/start.sh"]
