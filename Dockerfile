FROM python:3.12-slim

WORKDIR /ansible

# Install dependencies
RUN apt-get update && apt-get install -y \
    openssh-client \
    git \
    sudo \
    tree \
 && rm -rf /var/lib/apt/lists/*

# Install Ansible and passlib
RUN pip install --no-cache-dir ansible passlib

# Copy and set up the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default to interactive shell unless overridden
CMD ["bash"]
