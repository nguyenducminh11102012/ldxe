FROM portainer/portainer-ce:lts
RUN apt-get update && apt-get install -y iptables
CMD iptables -A OUTPUT -p tcp --dport 8000 -j DROP && /entrypoint.sh
