FROM ubuntu:latest

RUN apt install -y curl && \
    curl -L https://setup.runtipi.io | bash

CMD ["sleep", "infinity"]
