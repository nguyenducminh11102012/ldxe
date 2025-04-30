FROM ubuntu:22.04

# Biến môi trường
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV RESOLUTION=1024x768x16
ENV VNC_PORT=5901
ENV NOVNC_PORT=6080
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    wget \
    unzip \
    xvfb \
    fluxbox \
    x11vnc \
    novnc \
    websockify \
    libgl1-mesa-glx \
    libpulse0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Tạo user developer và thư mục SDK
RUN useradd -m developer && \
    mkdir -p /opt/android-sdk/cmdline-tools && \
    chown -R developer:developer /opt/android-sdk

# Tải Android Studio (CLI only)
RUN mkdir -p /opt/android-studio && \
    wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.24/android-studio-2023.1.1.24-linux.tar.gz -O /opt/android-studio/studio.tar.gz && \
    tar -xzf /opt/android-studio/studio.tar.gz -C /opt/android-studio --strip-components=1 && \
    rm /opt/android-studio/studio.tar.gz

# Tải và cài đặt Android SDK command-line tools
USER developer
WORKDIR /home/developer
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip -q cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools && \
    rm cmdline-tools.zip && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest

# Chấp nhận licenses SDK và cài đặt các thành phần cần thiết
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "emulator" "platforms;android-30" "system-images;android-30;google_apis;x86"

# Tạo AVD
RUN echo "no" | avdmanager create avd \
    --name "pixel_4" \
    --package "system-images;android-30;google_apis;x86" \
    --device "pixel_4" \
    --force

# Trở lại root để cấu hình script khởi động
USER root
RUN echo '#!/bin/bash\n\
Xvfb $DISPLAY -screen 0 $RESOLUTION +extension GLX +render -noreset >/dev/null 2>&1 &\n\
sleep 2\n\
fluxbox >/dev/null 2>&1 &\n\
sleep 1\n\
x11vnc -display $DISPLAY -forever -shared -rfbport $VNC_PORT -passwd android -bg \\\n\
        -noxdamage -xrandr -threads -nowf -nopw -wait 10 -defer 10 >/dev/null 2>&1 &\n\
websockify --web=/usr/share/novnc/ $NOVNC_PORT localhost:$VNC_PORT \\\n\
                --heartbeat=30 --timeout=45 >/dev/null 2>&1 &\n\
su - developer -c "export DISPLAY=$DISPLAY && \\\n\
    export QT_QUICK_BACKEND=software && \\\n\
    export LIBGL_ALWAYS_SOFTWARE=1 && \\\n\
    $ANDROID_HOME/emulator/emulator -avd pixel_4 \\\n\
    -no-audio -no-window -gpu swiftshader_indirect \\\n\
    -no-snapshot -no-boot-anim -no-accel -memory 1536 \\\n\
    -qemu -m 1536 -enable-kvm false"\n\
tail -f /dev/null' > /start.sh && chmod +x /start.sh

EXPOSE $VNC_PORT $NOVNC_PORT

CMD ["/start.sh"]
