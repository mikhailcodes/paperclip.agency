#!/bin/bash

echo "📊 Paperclip Menu Bar Indicator Setup"
echo "====================================="
echo ""

# Check if SwiftBar is installed
if [ ! -d "/Applications/SwiftBar.app" ]; then
  echo "SwiftBar not found. Installing via Homebrew..."

  if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Install from: https://brew.sh"
    exit 1
  fi

  brew install --cask swiftbar
  echo "✅ SwiftBar installed"
else
  echo "✅ SwiftBar already installed"
fi

# Create SwiftBar plugins directory
SWIFTBAR_PLUGINS="$HOME/Library/Application Support/SwiftBar/Plugins"
mkdir -p "$SWIFTBAR_PLUGINS"

# Create Paperclip status plugin
cat > "$SWIFTBAR_PLUGINS/paperclip.5s.sh" << 'EOF'
#!/bin/bash

# <xbar.title>Paperclip Status</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Mikhail</xbar.author>
# <xbar.desc>Shows Paperclip service status</xbar.desc>

# Check if Paperclip is running
if curl -s -f http://localhost:3100/health > /dev/null 2>&1; then
  echo "🤖✓"
  echo "---"
  echo "✅ Paperclip Running | color=green"
  echo "Open UI | bash=/usr/bin/open param1=http://localhost:3100 terminal=false"
  echo "---"
  echo "Restart Service | bash=$HOME/developer/paperclip.agency/scripts/paperclip-service.sh param1=restart terminal=true refresh=true"
  echo "Stop Service | bash=$HOME/developer/paperclip.agency/scripts/paperclip-service.sh param1=stop terminal=true refresh=true"
  echo "View Logs | bash=/usr/bin/open param1=-a param2=Console param3=$HOME/.paperclip/instances/default/logs/paperclip-service.log terminal=false"
else
  echo "🤖✗"
  echo "---"
  echo "❌ Paperclip Stopped | color=red"
  echo "Start Service | bash=$HOME/developer/paperclip.agency/scripts/paperclip-service.sh param1=start terminal=true refresh=true"
  echo "View Error Logs | bash=/usr/bin/open param1=-a param2=Console param3=$HOME/.paperclip/instances/default/logs/paperclip-service-error.log terminal=false"
fi

echo "---"
echo "Refresh | refresh=true"
EOF

chmod +x "$SWIFTBAR_PLUGINS/paperclip.5s.sh"

echo ""
echo "✅ Menu bar indicator installed!"
echo ""
echo "Next steps:"
echo "1. Open SwiftBar (check /Applications)"
echo "2. SwiftBar will ask for plugins folder"
echo "3. Point it to: $SWIFTBAR_PLUGINS"
echo "4. You'll see a robot icon (🤖) in your menu bar"
echo ""
echo "Menu bar features:"
echo "  🤖✓ - Paperclip is running (green)"
echo "  🤖✗ - Paperclip is stopped (red)"
echo "  Click to see options (Start, Stop, Restart, Open UI, Logs)"
echo ""
