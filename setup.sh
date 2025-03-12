#!/bin/bash

# Define workspace path
WORKSPACE="/workspaces/$(basename $PWD)"
DEVCONTAINER_PATH="$WORKSPACE/.devcontainer"

# Ensure we are in the workspace directory
mkdir -p "$DEVCONTAINER_PATH"

echo "🚀 Creating SUPER OPTIMIZED .devcontainer setup in $DEVCONTAINER_PATH..."

# Write devcontainer.json
cat <<EOF > "$DEVCONTAINER_PATH/devcontainer.json"
{
  "name": "Super Optimized Ubuntu Dev Container",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:1": {},
    "ghcr.io/devcontainers/features/docker-in-docker:2": {}
  },
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.defaultProfile.linux": "bash"
      },
      "extensions": [
        "ms-python.python",
        "ms-vscode.cpptools",
        "esbenp.prettier-vscode",
        "eamodio.gitlens",
        "ms-toolsai.jupyter",
        "github.copilot",
        "ms-python.vscode-pylance"
      ]
    }
  },
  "postCreateCommand": "bash /workspaces/$(basename $PWD)/.devcontainer/setup.sh",
  "remoteUser": "root",
  "mounts": [
    {
      "source": "\${localWorkspaceFolder}",
      "target": "/workspaces/$(basename $PWD)",
      "type": "bind"
    }
  ]
}
EOF

echo "✅ devcontainer.json created!"

# Write Dockerfile for system tuning
cat <<EOF > "$DEVCONTAINER_PATH/Dockerfile"
# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Install essential tools & performance tuning
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    curl git nano vim python3 python3-pip nodejs npm \
    build-essential cmake htop neofetch tlp docker.io \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Enable ZRAM for better memory management
RUN apt install -y zram-tools && \
    echo 'ALGO=lz4' > /etc/default/zramswap && \
    echo 'PERCENT=50' >> /etc/default/zramswap && \
    systemctl enable zramswap

# Enable and start Docker
RUN systemctl enable docker && systemctl start docker

# Set working directory
WORKDIR /workspaces/$(basename $PWD)

# Default shell
CMD ["/bin/bash"]
EOF

echo "✅ Dockerfile created!"

# Write setup.sh for post-creation system optimization
cat <<EOF > "$DEVCONTAINER_PATH/setup.sh"
#!/bin/bash

echo "🚀 Running post-creation setup for MAX PERFORMANCE..."

# Update & install necessary tools
apt update && apt install -y \
    jq zip unzip python3-venv tlp \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Enable CPU performance mode
echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Enable ZRAM swap
systemctl restart zramswap

# Install Node.js tools globally
npm install -g npm yarn pm2

# Increase file limits
echo '* soft nofile 1048576' | tee -a /etc/security/limits.conf
echo '* hard nofile 1048576' | tee -a /etc/security/limits.conf
ulimit -n 1048576

# Enable TLP for power management
systemctl enable tlp && systemctl start tlp

# Start Docker daemon
systemctl start docker

# Add user to Docker group to avoid sudo requirement
usermod -aG docker root

echo "✅ Setup complete! Super Optimized Codespace is READY 🚀🔥"
EOF

# Make the setup script executable
chmod +x "$DEVCONTAINER_PATH/setup.sh"
echo "✅ setup.sh created and made executable!"

# Prompt user to rebuild the Codespace
echo -e "\n🔄 **Now go to GitHub Codespaces and click 'Rebuild Container'** or run:\n"
echo "devcontainer rebuild-container"
