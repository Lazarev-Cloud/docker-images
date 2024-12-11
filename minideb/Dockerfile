# Use bitnami/minideb:bookworm as the base image
FROM bitnami/minideb:bookworm

# Install necessary packages
RUN install_packages openssh-server sudo

# Create SSH directory for the SSH daemon
RUN mkdir /var/run/sshd

# Generate SSH host keys unconditionally
RUN ssh-keygen -A

# Ensure the permissions are correct for SSH
RUN chown root:root /etc/ssh/sshd_config

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

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command to start SSH daemon
CMD ["/usr/sbin/sshd", "-D"]