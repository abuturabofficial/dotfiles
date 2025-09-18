#!/usr/bin/env bash
# Fully automated Kali Distrobox setup and enter script

NAME="kali"
HOME_DIR="$HOME/.containers/$NAME"
IMAGE="docker.io/kalilinux/kali-rolling:latest"
PACKAGES="systemd libpam-systemd pipewire-audio-client-libraries zsh"
# BOOTSTRAP="$HOME/.config/distrobox/init.d/kali-bootstrap.sh"

# Check if the container exists
if distrobox-list | grep -q "^$NAME\$"; then
    echo "🚀 Distrobox $NAME already exists. Entering..."
else
    echo "🚀 Creating Distrobox $NAME..."
    distrobox-create \
        --name "$NAME" \
        --init \
        --unshare-all \
        --home "$HOME_DIR" \
        --image "$IMAGE" \
        --additional-packages "$PACKAGES"
fi

# Run bootstrap script if it exists
if [ -f "$BOOTSTRAP" ]; then
    echo "⚡ Running bootstrap script inside $NAME..."
    distrobox-enter "$NAME" -- bash -c "bash $BOOTSTRAP"
fi

# Enter the container
echo "🐚 Entering Distrobox $NAME..."
distrobox-enter "$NAME"
