#!/bin/bash
# Railway Environment Setup Script
# Run this script to configure all required environment variables

set -e

echo "Setting up Railway environment variables for paperclip-agents..."

# Make sure we're linked to the right service
railway service paperclip-agents

# Link DATABASE_URL from Postgres service
echo "Linking DATABASE_URL from Postgres..."
railway variables set DATABASE_URL='${{Postgres.DATABASE_URL}}'

# Set JWT Secret
echo "Setting JWT secret..."
railway variables set PAPERCLIP_AGENT_JWT_SECRET="49b8888661d319be22fbb2094d663af05440dc887c5a09115bb164f74eccfca1"

# Set GitHub Token (you'll need to replace this with your actual token)
echo "Setting GitHub token..."
read -p "Enter your GitHub token (or press Enter to skip): " GITHUB_TOKEN
if [ -n "$GITHUB_TOKEN" ]; then
  railway variables set GITHUB_TOKEN="$GITHUB_TOKEN"
else
  echo "Skipping GitHub token (you can set it later)"
fi

# Optional: Set Slack variables
read -p "Set Slack variables? (y/n): " SET_SLACK
if [ "$SET_SLACK" = "y" ]; then
  read -p "Enter your Slack Bot Token (xoxb-...): " SLACK_BOT_TOKEN
  read -p "Enter your Slack Signing Secret: " SLACK_SIGNING_SECRET
  railway variables set SLACK_BOT_TOKEN="$SLACK_BOT_TOKEN"
  railway variables set SLACK_SIGNING_SECRET="$SLACK_SIGNING_SECRET"
  echo "Slack variables set"
fi

echo ""
echo "Environment variables configured! Checking current variables..."
railway variables

echo ""
echo "Setup complete! Ready to deploy with: railway up"
