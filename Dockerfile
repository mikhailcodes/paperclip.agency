# Paperclip Deployment Dockerfile
FROM node:20-alpine

# Install Paperclip CLI globally
RUN npm install -g paperclipai

# Set working directory
WORKDIR /app

# Create instance directory
RUN mkdir -p /app/instance

# Copy configuration files
COPY config.json /app/instance/config.json

# Expose port
EXPOSE 3100

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3100/health || exit 1

# Start Paperclip
CMD ["paperclip", "start", "--instance-dir", "/app/instance"]
