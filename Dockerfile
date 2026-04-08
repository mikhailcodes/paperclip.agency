# Paperclip Deployment Dockerfile
# Using Debian-based image for better Claude Code compatibility
FROM node:20-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    wget \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user for running Paperclip
RUN useradd -m -s /bin/bash paperclip && \
    echo "paperclip ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Paperclip CLI globally
RUN npm install -g paperclipai

# Switch to paperclip user for Claude installation
USER paperclip

# Install Claude Code CLI using native installer as non-root user
RUN curl -fsSL https://claude.ai/install.sh | bash

# Add Claude to PATH
ENV PATH="/home/paperclip/.local/bin:${PATH}"

# Verify Claude is accessible
RUN which claude && claude --version || echo "WARNING: Claude not accessible"

# Switch back to root to set up directories
USER root

# Set working directory
WORKDIR /app

# Create instance and workspaces directories
RUN mkdir -p /app/instance /app/instance/workspaces

# Copy configuration files
COPY config.json /app/instance/config.json

# Install Paperclip plugins as paperclip user
RUN mkdir -p /home/paperclip/.paperclip/plugins && \
    chown -R paperclip:paperclip /home/paperclip/.paperclip

USER paperclip
RUN cd /home/paperclip/.paperclip/plugins && \
    npm init -y && \
    npm install @yesterday-ai/paperclip-plugin-company-wizard@^0.1.15 paperclip-plugin-slack@^2.0.6

# Switch back to root to set permissions
USER root
RUN chown -R paperclip:paperclip /app/instance

# Switch to paperclip user for runtime
USER paperclip

# Expose port
EXPOSE 3100

# Health check (runs as paperclip user)
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3100/health || exit 1

# Start Paperclip as paperclip user
CMD ["paperclipai", "run", "--data-dir", "/app/instance", "--config", "/app/instance/config.json"]
