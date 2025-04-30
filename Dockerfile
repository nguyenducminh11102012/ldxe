FROM ubuntu:22.04

# Biến môi trường
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
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

# Cấu hình script khởi động
USER root
RUN echo '#!/bin/bash\n\
# Khởi động Xvfb\n\
Xvfb $DISPLAY -screen 0 800x600x16 +extension GLX +render -noreset >/dev/null 2>&1 &\n\
sleep 2\n\
\n\
# Khởi động window manager\n\
fluxbox >/dev/null 2>&1 &\n\
sleep 1\n\
\n\
# Khởi động x11vnc\n\
x11vnc -display $DISPLAY -forever -shared -rfbport $VNC_PORT -passwd android -bg \\\n\
       -noxdamage -xrandr -threads -nowf -nopw -wait 10 -defer 10 >/dev/null 2>&1\n\
\n\
# Khởi động NoVNC\n\
websockify --web=/usr/share/novnc/ $NOVNC_PORT localhost:$VNC_PORT \\\n\
           --heartbeat=30 --timeout=45 >/dev/null 2>&1 &\n\
\n\
# Khởi động Android emulator với software rendering\n\
su - android -c "export DISPLAY=$DISPLAY && \\\n\
    export QT_QUICK_BACKEND=software && \\\n\
    export LIBGL_ALWAYS_SOFTWARE=1 && \\\n\
    $ANDROID_HOME/emulator/emulator -avd pixel_4 \\\n\
    -no-audio \\\n\
    -no-window \\\n\
    -gpu swiftshader_indirect \\\n\
    -no-snapshot \\\n\
    -no-boot-anim \\\n\
    -no-accel \\\n\
    -memory 1536 \\\n\
    -qemu -m 1536 -enable-kvm false"\n\
\n\
# Giữ container chạy\n\
tail -f /dev/null' > /start.sh && \
    chmod +x /start.sh

EXPOSE $VNC_PORT $NOVNC_PORT

USER developer
WORKDIR /home/developer
CMD ["/start.sh"]
