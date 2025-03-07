FROM pufferpanel/pufferpanel:latest

RUN mkdir -p /var/lib/pufferpanel

EXPOSE 8080
EXPOSE 5657

#Thử tạo group pufferpanel trước, và tạo user sau.
RUN groupadd pufferpanel
RUN /pufferpanel/pufferpanel user add --name root --password Binhminh12 --admin

CMD ["/pufferpanel/pufferpanel"]
