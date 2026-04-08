#!/bin/bash
# Script to reinstall Slack plugin remotely on Railway

set -e

echo "🔧 Reinstalling Slack plugin on Railway..."
echo ""

# Step 1: Uninstall the errored Slack plugin
echo "Step 1: Uninstalling existing Slack plugin..."
railway run --service paperclip-agents -- paperclipai plugin uninstall paperclip-plugin-slack --force --data-dir /app/instance --config /app/instance/config.json

echo ""
echo "Step 2: Installing fresh Slack plugin..."
railway run --service paperclip-agents -- paperclipai plugin install paperclip-plugin-slack@2.0.6 --data-dir /app/instance --config /app/instance/config.json

echo ""
echo "✅ Slack plugin reinstalled!"
echo ""
echo "Next steps:"
echo "1. Go to https://paperclip-agents-production.up.railway.app"
echo "2. Navigate to Settings → Plugins"
echo "3. Click 'Configure' on the Slack Chat OS plugin"
echo "4. Enter your Slack credentials:"
echo "   - Bot Token: (your xoxb-... token)"
echo "   - Signing Secret: (your signing secret)"
echo "5. Save and enable the plugin"
echo ""
