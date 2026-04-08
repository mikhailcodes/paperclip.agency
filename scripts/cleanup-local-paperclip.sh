#!/bin/bash
set -e

echo "🧹 Paperclip Local Cleanup Script"
echo "=================================="
echo ""
echo "This script will remove Paperclip from your local machine."
echo "⚠️  Make sure you've migrated to Railway before running this!"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if backup exists
if [ ! -f "$HOME/.paperclip/instances/default/data/backups/paperclip-20260407-195154.sql" ]; then
  echo -e "${YELLOW}⚠️  Warning: No recent backup found!${NC}"
  echo "Do you want to create a backup before cleanup? (y/n)"
  read -r CREATE_BACKUP

  if [ "$CREATE_BACKUP" = "y" ]; then
    echo "Creating backup..."
    mkdir -p ./backups
    cp -r "$HOME/.paperclip/instances/default/data/backups" ./backups/ 2>/dev/null || echo "No backups to copy"
    echo -e "${GREEN}✅ Backup saved to ./backups/${NC}"
  fi
fi

echo ""
echo "Items to be deleted:"
echo "-------------------"
echo "1. Paperclip CLI (npm global): paperclipai@2026.403.0"
echo "   Location: /opt/homebrew/lib/node_modules/paperclipai"
echo "   Size: ~50MB"
echo ""
echo "2. Paperclip instance data: ~/.paperclip/"
echo "   - Instance data: ~/.paperclip/instances/default (116MB)"
echo "   - Plugins: ~/.paperclip/plugins (55MB)"
echo "   Total size: ~171MB"
echo ""
echo "3. Slack plugin dev folder: /Users/mikhail/paperclip-plugins/slack"
echo "   Size: 56MB"
echo ""
echo "Total space to free: ~277MB"
echo ""
echo -e "${RED}⚠️  This action cannot be undone!${NC}"
echo "Are you sure you want to proceed? (type 'yes' to confirm)"
read -r CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Cleanup cancelled."
  exit 0
fi

echo ""
echo "Starting cleanup..."
echo ""

# Step 1: Uninstall npm global package
echo "Step 1: Uninstalling Paperclip CLI..."
npm uninstall -g paperclipai
echo -e "${GREEN}✅ Paperclip CLI uninstalled${NC}"
echo ""

# Step 2: Remove instance data
echo "Step 2: Removing Paperclip instance data..."
rm -rf "$HOME/.paperclip"
echo -e "${GREEN}✅ Instance data removed${NC}"
echo ""

# Step 3: Remove Slack plugin folder
echo "Step 3: Removing Slack plugin development folder..."
rm -rf /Users/mikhail/paperclip-plugins/slack
echo -e "${GREEN}✅ Slack plugin folder removed${NC}"
echo ""

# Step 4: Remove parent folder if empty
if [ -d "/Users/mikhail/paperclip-plugins" ] && [ -z "$(ls -A /Users/mikhail/paperclip-plugins)" ]; then
  echo "Step 4: Removing empty paperclip-plugins folder..."
  rmdir /Users/mikhail/paperclip-plugins
  echo -e "${GREEN}✅ Empty parent folder removed${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Cleanup complete!${NC}"
echo ""
echo "Freed up approximately 277MB of disk space."
echo ""
echo "Your Paperclip instance is now running on Railway:"
echo "👉 Check your Railway dashboard for the URL"
echo ""
