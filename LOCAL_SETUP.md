# Paperclip Local Setup Guide

Complete guide to running Paperclip locally with Tailscale Funnel, background service, and menu bar status.

---

## Overview

This setup gives you:
- ✅ Paperclip running 24/7 as a background service
- ✅ Tailscale Funnel for Slack webhooks (free, permanent URL)
- ✅ Menu bar indicator showing status
- ✅ Easy service management (start, stop, restart)

---

## Step 1: Set Up Tailscale Funnel

### Install Tailscale CLI
```bash
# Add Tailscale to your PATH
sudo ln -s /Applications/Tailscale.app/Contents/MacOS/Tailscale /usr/local/bin/tailscale
```

### Enable Funnel
```bash
# Make sure Paperclip is running first
paperclipai start

# In a new terminal, enable Tailscale Funnel
tailscale funnel 3100
```

This will give you a permanent HTTPS URL like:
```
https://mikhails-macbook.tail1234.ts.net
```

**Save this URL!** You'll use it for Slack webhooks.

---

## Step 2: Set Up Background Service

### Install the LaunchAgent
The LaunchAgent is already created at:
```
~/Library/LaunchAgents/com.paperclip.agent.plist
```

### Start the service
```bash
cd ~/developer/paperclip.agency
./scripts/paperclip-service.sh start
```

### Service Commands
```bash
./scripts/paperclip-service.sh status   # Check if running
./scripts/paperclip-service.sh stop     # Stop service
./scripts/paperclip-service.sh restart  # Restart service
./scripts/paperclip-service.sh logs     # View logs
./scripts/paperclip-service.sh errors   # View error logs
```

**Now Paperclip runs automatically:**
- ✅ Starts on login
- ✅ Restarts if it crashes
- ✅ Runs in background (no terminal needed)

---

## Step 3: Install Menu Bar Indicator

### Install SwiftBar and create status indicator
```bash
cd ~/developer/paperclip.agency
./scripts/install-menu-bar-indicator.sh
```

This will:
1. Install SwiftBar (menu bar app runner)
2. Create Paperclip status plugin
3. Add robot icon to your menu bar

### Menu Bar Features
**Status Icons:**
- 🤖✓ - Paperclip is running (green)
- 🤖✗ - Paperclip is stopped (red)

**Click the icon to:**
- Open Paperclip UI
- Start/Stop/Restart service
- View logs
- Refresh status

Updates every 5 seconds automatically.

---

## Step 4: Update Slack Webhooks

Go to your [Slack App Settings](https://api.slack.com/apps/A0AR8SZGYMR)

**Use your Tailscale Funnel URL** (from Step 1):

### Interactivity & Shortcuts
```
https://YOUR-TAILSCALE-URL/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slack-interactivity
```

### Slash Commands (/clip)
```
https://YOUR-TAILSCALE-URL/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slash-command
```

### Event Subscriptions
```
https://YOUR-TAILSCALE-URL/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slack-events
```

**Test the webhooks:**
- Slack will verify each webhook URL
- Should show green checkmarks if successful

---

## Step 5: Add GitHub Token

To let agents create GitHub issues/PRs:

### Create GitHub Token
1. Go to: https://github.com/settings/tokens/new
2. Name: `Paperclip Agent Access`
3. Scopes: ✅ `repo`, ✅ `project`
4. Generate token

### Add to Paperclip
```bash
# Open Paperclip UI
open http://localhost:3100

# Go to Settings → Integrations → GitHub
# Paste your token
```

Now agents can create issues, PRs, and sync with GitHub Projects!

---

## Troubleshooting

### Service won't start
```bash
# Check error logs
tail -f ~/.paperclip/instances/default/logs/paperclip-service-error.log

# Try manual start
paperclipai start
```

### Tailscale Funnel not working
```bash
# Check Tailscale status
tailscale status

# Make sure you're connected
# Open Tailscale app and connect

# Restart funnel
tailscale funnel 3100
```

### Menu bar not showing
```bash
# Open SwiftBar
open /Applications/SwiftBar.app

# Check plugin folder
ls -la ~/Library/Application\ Support/SwiftBar/Plugins/

# Refresh SwiftBar
# Click SwiftBar icon → Preferences → Refresh All
```

### Slack webhooks failing
```bash
# Make sure Tailscale Funnel is running
tailscale status

# Check Paperclip is responding
curl http://localhost:3100/health

# Verify webhook URLs in Slack app settings
```

---

## Daily Usage

### Normal Workflow
1. **Laptop starts** → Paperclip auto-starts (LaunchAgent)
2. **Check status** → Look at menu bar icon (🤖✓)
3. **Use Slack** → Create issues with `/clip`, approve with buttons
4. **Check UI** → Click menu bar → "Open UI"

### If something breaks
1. Click menu bar icon
2. Click "View Error Logs"
3. Or run: `~/developer/paperclip.agency/scripts/paperclip-service.sh restart`

---

## Benefits of This Setup

✅ **Always Running**: Service starts on login, restarts if crashes
✅ **Visible Status**: Menu bar shows if it's working
✅ **Free Tunneling**: Tailscale Funnel is free and secure
✅ **Easy Management**: Simple scripts for all operations
✅ **GitHub Integration**: Agents can work on repos
✅ **Slack Integration**: Full webhook support

---

## What Runs When

**Always running:**
- Paperclip service (background)
- Tailscale (background)

**When laptop is on:**
- Tailscale Funnel (expose to Slack)
- Menu bar indicator (SwiftBar)

**On demand:**
- Paperclip UI (browser)

---

## File Locations

**Service:**
- LaunchAgent: `~/Library/LaunchAgents/com.paperclip.agent.plist`
- Instance data: `~/.paperclip/instances/default/`
- Logs: `~/.paperclip/instances/default/logs/`

**Scripts:**
- Service manager: `~/developer/paperclip.agency/scripts/paperclip-service.sh`
- Menu bar: `~/Library/Application Support/SwiftBar/Plugins/paperclip.5s.sh`
- Tailscale setup: `~/developer/paperclip.agency/scripts/setup-tailscale-funnel.sh`

---

## Next Steps

After setup is complete:
1. Test Slack `/clip` command
2. Create a test issue
3. Approve it from Slack (test buttons)
4. Let an agent create a GitHub issue
5. Monitor via menu bar

Enjoy your always-on Paperclip setup! 🚀
