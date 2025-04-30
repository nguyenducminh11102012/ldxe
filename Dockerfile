FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV ANDROID_HOME=/home/developer/Android/Sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Cài các phần mềm cần thiết
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk wget curl git unzip \
    x11vnc xvfb openbox sudo \
    novnc websockify net-tools \
    && rm -rf /var/lib/apt/lists/*

# Tạo user thường để chạy GUI
RUN useradd -m developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Cài Android Studio
RUN mkdir -p /opt/android-studio && \
    wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.24/android-studio-2023.1.1.24-linux.tar.gz -O studio.tar.gz && \
    tar -xzf studio.tar.gz -C /opt/android-studio --strip-components=1 && \
    rm studio.tar.gz

# Script khởi động các dịch vụ
CMD bash -c "\
    Xvfb :1 -screen 0 1280x800x16 & \
    sleep 2 && \
    sudo -u developer openbox & \
    sudo -u developer /opt/android-studio/bin/studio.sh & \
    x11vnc -display :1 -nopw -forever -shared & \
    websockify --web=/usr/share/novnc/ 6080 localhost:5900 \
"
