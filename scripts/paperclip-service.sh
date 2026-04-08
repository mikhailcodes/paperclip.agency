#!/bin/bash

# Paperclip Service Management Script
# Manages Paperclip as a background service on macOS

PLIST_PATH="$HOME/Library/LaunchAgents/com.paperclip.agent.plist"
SERVICE_NAME="com.paperclip.agent"

case "$1" in
  start)
    echo "Starting Paperclip service..."
    launchctl load "$PLIST_PATH" 2>/dev/null || launchctl start "$SERVICE_NAME"
    sleep 2
    if curl -s http://localhost:3100/health > /dev/null 2>&1; then
      echo "✅ Paperclip is running at http://localhost:3100"
    else
      echo "❌ Paperclip failed to start. Check logs:"
      echo "  tail -f ~/.paperclip/instances/default/logs/paperclip-service-error.log"
    fi
    ;;

  stop)
    echo "Stopping Paperclip service..."
    launchctl unload "$PLIST_PATH" 2>/dev/null || launchctl stop "$SERVICE_NAME"
    echo "✅ Paperclip stopped"
    ;;

  restart)
    echo "Restarting Paperclip service..."
    $0 stop
    sleep 2
    $0 start
    ;;

  status)
    if curl -s http://localhost:3100/health > /dev/null 2>&1; then
      echo "✅ Paperclip is running"
      echo "   UI: http://localhost:3100"
      if launchctl list | grep -q "$SERVICE_NAME"; then
        echo "   Service: Loaded in LaunchAgent"
      fi
    else
      echo "❌ Paperclip is not running"
      if launchctl list | grep -q "$SERVICE_NAME"; then
        echo "   Service: Loaded but not responding"
        echo "   Check logs: tail -f ~/.paperclip/instances/default/logs/paperclip-service-error.log"
      else
        echo "   Service: Not loaded"
        echo "   Run: $0 start"
      fi
    fi
    ;;

  logs)
    echo "Showing Paperclip logs (Ctrl+C to exit)..."
    tail -f ~/.paperclip/instances/default/logs/paperclip-service.log
    ;;

  errors)
    echo "Showing Paperclip error logs (Ctrl+C to exit)..."
    tail -f ~/.paperclip/instances/default/logs/paperclip-service-error.log
    ;;

  *)
    echo "Paperclip Service Manager"
    echo "========================"
    echo ""
    echo "Usage: $0 {start|stop|restart|status|logs|errors}"
    echo ""
    echo "Commands:"
    echo "  start   - Start Paperclip as a background service"
    echo "  stop    - Stop Paperclip service"
    echo "  restart - Restart Paperclip service"
    echo "  status  - Check if Paperclip is running"
    echo "  logs    - Show service logs (live tail)"
    echo "  errors  - Show error logs (live tail)"
    echo ""
    exit 1
    ;;
esac
