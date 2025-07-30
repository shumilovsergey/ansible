# Dockerfile
FROM python:3.12-slim

WORKDIR /ansible

RUN apt-get update && apt-get install -y \
    openssh-client \
    git \
    sudo \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir ansible passlib

CMD ["bash"]

