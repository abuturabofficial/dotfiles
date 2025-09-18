#!/usr/bin/env bash
# Minimal bootstrap script for Kali Distrobox
# Run this *inside* your Kali Distrobox after creation

set -e

echo "🔧 Updating package lists..."
sudo apt update -y

echo "📦 Installing base packages..."
sudo apt install -y \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    zoxide \
    neovim \
    bat \
    command-not-found \
    tealdeer

echo "🐚 Setting zsh as default shell..."
chsh -s /usr/bin/zsh

echo "⚡ Configuring zoxide in ~/.zshrc..."
if ! grep -q 'zoxide init zsh' ~/.zshrc 2>/dev/null; then
    echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
fi

echo "✅ Bootstrap complete! Restart your shell or run 'zsh' to switch."
