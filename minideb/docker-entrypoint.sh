#!/bin/bash
set -e

# -------------------------------
# Configuration Variables
# -------------------------------

# SSH_USER: Username for SSH access (default: lazarev)
SSH_USER=${SSH_USER:-lazarev}

# SSH_PUBLIC_KEY: Base64-encoded Public SSH key for authentication (default: empty)
SSH_PUBLIC_KEY=${SSH_PUBLIC_KEY:-}

# -------------------------------
# SSH Directory and Permissions
# -------------------------------

# Define the path for authorized_keys
AUTHORIZED_KEYS_PATH="/home/$SSH_USER/.ssh/authorized_keys"

# Create the .ssh directory if it doesn't exist (redundant if created in Dockerfile)
mkdir -p /home/"$SSH_USER"/.ssh
chmod 700 /home/"$SSH_USER"/.ssh

# -------------------------------
# Authorized Keys Setup
# -------------------------------

if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "Decoding and setting up authorized_keys for user: $SSH_USER"
    echo "$SSH_PUBLIC_KEY" | base64 --decode > "$AUTHORIZED_KEYS_PATH"
    chmod 600 "$AUTHORIZED_KEYS_PATH"
    chown "$SSH_USER":"$SSH_USER" "$AUTHORIZED_KEYS_PATH"
else
    echo "No SSH_PUBLIC_KEY provided. SSH access will not be available for user: $SSH_USER."
fi

# -------------------------------
# SSH Server Configuration (Optional)
# -------------------------------

# (Optional) Disable password authentication for enhanced security
# Uncomment the following lines if you want to enforce key-based authentication only

# echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
# echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# -------------------------------
# Start SSH Daemon
# -------------------------------

echo "Starting SSH daemon..."
exec "$@"