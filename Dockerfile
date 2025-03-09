# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies and Webmin
RUN apt update && apt install -y wget apt-transport-https software-properties-common gnupg \
    && wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add - \
    && echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list \
    && apt update && apt install -y webmin \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Set Webmin root password
RUN echo "root:admin123" | chpasswd

# Expose Webmin default port
EXPOSE 10000

# Start Webmin service
CMD ["/etc/init.d/webmin", "start" && tail -f /dev/null]
