#!/bin/bash

# Paperclip Status Menu Bar Script
# This script checks if Paperclip is running and outputs status

# Check if Paperclip is running on port 3100
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3100/health 2>/dev/null | grep -q "200"; then
  echo "✅ Paperclip"
else
  echo "❌ Paperclip"
fi
