# Bắt đầu từ Ubuntu
FROM ubuntu:latest

# Cập nhật và cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    tmate \
    python3 \
    python3-pip \
    python3-flask \
    wget \
    && apt-get clean

# Cài đặt Flask
RUN pip3 install Flask

# Tạo ứng dụng Flask
RUN echo 'from flask import Flask\n\
import subprocess\n\
import os\n\
\n\
app = Flask(__name__)\n\
\n\
@app.route("/")\n\
def index():\n\
    # Khởi động tmate và lấy session URL\n\
    result = subprocess.run(["tmate", "-F"], stdout=subprocess.PIPE)\n\
    tmate_url = result.stdout.decode("utf-8").split("\n")[0]\n\
    return f"<h1>tmate Session URL</h1><p>{tmate_url}</p>"\n\
\n\
if __name__ == "__main__":\n\
    app.run(host="0.0.0.0", port=8080)' > /root/app.py

# Tạo script để khởi động Flask và tmate
RUN echo '#!/bin/bash\n\
tmate -F &\n\
python3 /root/app.py\n\
' > /root/start.sh

# Cấp quyền thực thi cho script
RUN chmod +x /root/start.sh

# Chạy khi container được khởi động
CMD /root/start.sh
