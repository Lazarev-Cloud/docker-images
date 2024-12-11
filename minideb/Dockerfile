# Use bitnami/minideb:bookworm as the base image
FROM bitnami/minideb:bookworm

# Install necessary packages
RUN install_packages openssh-server sudo

# Create the necessary SSH directories
RUN mkdir -p /var/run/sshd

# Ensure proper permissions for SSH directory
RUN chmod 755 /var/run/sshd

# Generate or check ssh keys only if they do not exist
RUN [ ! -f /etc/ssh/ssh_host_rsa_key ] && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""
RUN [ ! -f /etc/ssh/ssh_host_ecdsa_key ] && ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
RUN [ ! -f /etc/ssh/ssh_host_ed25519_key ] && ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

# Rest of your Dockerfile here

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