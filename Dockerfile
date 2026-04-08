# Paperclip Deployment Dockerfile
# Using Debian-based image for better Claude Code compatibility
FROM node:20-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Install Paperclip CLI globally
RUN npm install -g paperclipai

# Install Claude Code CLI using native installer
RUN curl -fsSL https://claude.ai/install.sh | bash && \
    # Symlink to make it available globally
    ln -sf /root/.local/bin/claude /usr/local/bin/claude && \
    # Verify installation
    claude --version || echo "Claude installation check"

# Set working directory
WORKDIR /app

# Create instance and workspaces directories
RUN mkdir -p /app/instance /app/instance/workspaces

# Copy configuration files
COPY config.json /app/instance/config.json

# Install Paperclip plugins
RUN mkdir -p /root/.paperclip/plugins && \
    cd /root/.paperclip/plugins && \
    npm init -y && \
    npm install @yesterday-ai/paperclip-plugin-company-wizard@^0.1.15 paperclip-plugin-slack@^2.0.6

# Expose port
EXPOSE 3100

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3100/health || exit 1

# Start Paperclip
CMD ["paperclipai", "run", "--data-dir", "/app/instance", "--config", "/app/instance/config.json"]
