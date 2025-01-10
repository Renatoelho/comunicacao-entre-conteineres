FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

RUN apt update && \
    apt install iputils-ping -y

ENTRYPOINT tail -f /dev/null
