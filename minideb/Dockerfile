# Use bitnami/minideb:bookworm as the base image
FROM bitnami/minideb:bookworm

# Install OpenSSH Server and sudo
RUN install_packages openssh-server sudo

# Create SSH directory
RUN mkdir /var/run/sshd

# Create a non-root user 'lazarev'
RUN useradd -m -s /bin/bash lazarev

# Set a password for 'lazarev' (optional)
# It's recommended to use SSH keys instead of passwords for authentication
# RUN echo 'lazarev:your_password_here' | chpasswd

# Copy the updated entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set the ownership of SSH directories
RUN chown -R lazarev:lazarev /home/lazarev/.ssh

# Expose SSH port
EXPOSE 22

# Switch to the 'lazarev' user
USER lazarev

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command to start SSH daemon
CMD ["/usr/sbin/sshd", "-D"]