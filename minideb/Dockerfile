# Use bitnami/minideb:bookworm as the base image
FROM bitnami/minideb:bookworm

# Install necessary packages
RUN install_packages openssh-server sudo

# Create SSH directory for the SSH daemon
RUN mkdir /var/run/sshd

# Generate SSH host keys
# Check if the RSA key does not exist
RUN [ ! -f /etc/ssh/ssh_host_rsa_key ] && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""

# Check if the ECDSA key does not exist
RUN [ ! -f /etc/ssh/ssh_host_ecdsa_key ] && ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""

# Check if the ED25519 key does not exist
RUN [ ! -f /etc/ssh/ssh_host_ed25519_key ] && ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

# Create a group and user with specific UID and GID
RUN groupadd -g 1000 lazarev && \
    useradd -m -u 1000 -g lazarev -s /bin/bash lazarev

# Create the .ssh directory and set ownership
RUN mkdir -p /home/lazarev/.ssh && \
    chown -R lazarev:lazarev /home/lazarev/.ssh

# Copy the updated entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose SSH port
EXPOSE 22

# Switch to the 'lazarev' user
USER lazarev

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command to start SSH daemon
CMD ["/usr/sbin/sshd", "-D"]