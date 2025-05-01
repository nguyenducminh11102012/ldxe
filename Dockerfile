FROM debian:bullseye-slim

RUN apt update && \
    apt install -y \
    ttyd \
    bash \
    wget \
    curl \
    vim && \
    apt clean

RUN useradd -m -s /bin/bash termuser

EXPOSE 7681

CMD ["ttyd", "-p", "-W", "7681", "-t", "title=My Remote Terminal", "-t", "rendererType=webgl", "bash"]
