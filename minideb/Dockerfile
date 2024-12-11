# Use bitnami/minideb:bookworm as the base image
FROM bitnami/minideb:bookworm

# Install OpenSSH Server and sudo
RUN install_packages openssh-server sudo

# Create SSH directory
RUN mkdir /var/run/sshd

# Copy the updated entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose SSH port
EXPOSE 22

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command to start SSH daemon
CMD ["/usr/sbin/sshd", "-D"]