# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Remove potential lock files to prevent apt issues
RUN rm -rf /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock* \
    && dpkg --configure -a

# Install required dependencies and Webmin
RUN apt update && sleep 5 && apt install -y wget apt-transport-https software-properties-common gnupg \
    && wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add - \
    && echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list \
    && apt update && sleep 5 && apt install -y webmin \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Set Webmin root password
RUN echo -e "admin:admin123" | chpasswd

# Expose Webmin default port
EXPOSE 10000

# Start Webmin service
CMD ["/usr/bin/perl", "/usr/share/webmin/miniserv.pl", "/etc/webmin/miniserv.conf"]
