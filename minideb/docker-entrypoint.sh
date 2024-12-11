#!/bin/bash
set -e

# -------------------------------
# Configuration Variables
# -------------------------------

# SSH_USER: Username for SSH access (default: lazarev)
SSH_USER=${SSH_USER:-lazarev}

# SSH_PUBLIC_KEY: Public SSH key from K8s secret (already decoded)
SSH_PUBLIC_KEY=${SSH_PUBLIC_KEY:-}

# -------------------------------
# SSH Directory and Permissions
# -------------------------------

# Define the path for authorized_keys
AUTHORIZED_KEYS_PATH="/home/$SSH_USER/.ssh/authorized_keys"

# Create the .ssh directory if it doesn't exist
mkdir -p /home/"$SSH_USER"/.ssh
chmod 700 /home/"$SSH_USER"/.ssh

# -------------------------------
# Authorized Keys Setup
# -------------------------------

if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "Setting up authorized_keys for user: $SSH_USER"
    echo "$SSH_PUBLIC_KEY" > "$AUTHORIZED_KEYS_PATH"
    chmod 600 "$AUTHORIZED_KEYS_PATH"
    chown "$SSH_USER":"$SSH_USER" "$AUTHORIZED_KEYS_PATH"
else
    echo "No SSH_PUBLIC_KEY provided. SSH access will not be available for user: $SSH_USER."
fi

# -------------------------------
# SSH Server Configuration
# -------------------------------

# Ensure SSH host keys exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
fi

# -------------------------------
# Start SSH Daemon
# -------------------------------

echo "Starting SSH daemon..."
exec "$@"