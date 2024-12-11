#!/bin/bash
set -e

# -------------------------------
# Configuration Variables
# -------------------------------

# SSH_USER: Username for SSH access (default: sshuser)
SSH_USER=${SSH_USER:-sshuser}

# SSH_PUBLIC_KEY_BASE64: Base64-encoded Public SSH key for authentication (default: empty)
SSH_PUBLIC_KEY_BASE64=${SSH_PUBLIC_KEY_BASE64:-}

# -------------------------------
# User Setup
# -------------------------------

# Check if the SSH user already exists; if not, create the user
if ! id -u "$SSH_USER" >/dev/null 2>&1; then
    echo "Creating user: $SSH_USER"
    useradd -m -s /bin/bash "$SSH_USER"
else
    echo "User $SSH_USER already exists."
fi

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

if [ -n "$SSH_PUBLIC_KEY_BASE64" ]; then
    echo "Decoding and setting up authorized_keys for user: $SSH_USER"
    echo "$SSH_PUBLIC_KEY_BASE64" | base64 --decode > "$AUTHORIZED_KEYS_PATH"
    chmod 600 "$AUTHORIZED_KEYS_PATH"
    chown -R "$SSH_USER":"$SSH_USER" /home/"$SSH_USER"/.ssh
else
    echo "No SSH_PUBLIC_KEY_BASE64 provided. SSH access will not be available for user: $SSH_USER."
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