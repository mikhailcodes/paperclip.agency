#!/bin/bash
set -e

echo "🔌 Tailscale Funnel Setup for Paperclip"
echo "========================================"
echo ""

# Check if Tailscale is installed
if [ ! -d "/Applications/Tailscale.app" ]; then
  echo "❌ Tailscale not found!"
  echo "Install from: https://tailscale.com/download/mac"
  exit 1
fi

echo "✅ Tailscale app found"
echo ""

# Check if Tailscale CLI is available
if ! command -v tailscale &> /dev/null; then
  echo "Setting up Tailscale CLI..."
  echo "Run this command to add Tailscale to your PATH:"
  echo ""
  echo "  sudo ln -s /Applications/Tailscale.app/Contents/MacOS/Tailscale /usr/local/bin/tailscale"
  echo ""
  echo "Or add to your ~/.zshrc:"
  echo "  export PATH=\"/Applications/Tailscale.app/Contents/MacOS:\$PATH\""
  echo ""
  exit 1
fi

# Check if Tailscale is connected
echo "Checking Tailscale status..."
if ! tailscale status &> /dev/null; then
  echo "⚠️  Tailscale is not connected"
  echo "Please open Tailscale app and connect to your network"
  exit 1
fi

echo "✅ Tailscale is connected"
echo ""

# Enable Tailscale Funnel
echo "Step 1: Enable Tailscale Funnel (HTTPS)"
echo "---------------------------------------"
echo "This will expose your local Paperclip (port 3100) to the internet"
echo ""
echo "Run this command:"
echo ""
echo "  tailscale funnel 3100"
echo ""
echo "This will give you a public HTTPS URL like:"
echo "  https://your-machine-name.your-tailnet.ts.net"
echo ""
echo "Step 2: Update Slack Webhooks"
echo "------------------------------"
echo "After enabling funnel, you'll get a URL. Use it to update:"
echo ""
echo "Slack App Settings: https://api.slack.com/apps/A0AR8SZGYMR"
echo ""
echo "Update these webhooks:"
echo "  Interactivity: https://YOUR-FUNNEL-URL/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slack-interactivity"
echo "  Slash Commands: https://YOUR-FUNNEL-URL/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slash-command"
echo "  Event Subscriptions: https://YOUR-FUNNEL-URL/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slack-events"
echo ""

echo "✅ Setup guide complete!"
echo ""
echo "Next steps:"
echo "1. Run: tailscale funnel 3100"
echo "2. Copy the HTTPS URL it provides"
echo "3. Update Slack webhook URLs with that URL"
echo "4. Test Slack approvals"
