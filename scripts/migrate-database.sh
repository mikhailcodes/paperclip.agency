#!/bin/bash
set -e

echo "📦 Paperclip Database Migration Script"
echo "======================================"
echo ""

# Step 1: Export local database
echo "Step 1: Exporting local database..."
LOCAL_BACKUP="$HOME/.paperclip/instances/default/data/backups"
LATEST_BACKUP=$(ls -t "$LOCAL_BACKUP"/*.sql 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
  echo "❌ No backup found. Creating new backup..."
  pg_dump -h localhost -p 54329 -U postgres paperclip > ./local-backup.sql
  echo "✅ Backup created: ./local-backup.sql"
  BACKUP_FILE="./local-backup.sql"
else
  echo "✅ Found recent backup: $LATEST_BACKUP"
  cp "$LATEST_BACKUP" ./local-backup.sql
  BACKUP_FILE="./local-backup.sql"
fi

echo ""
echo "Step 2: Ready to import to Railway"
echo "-----------------------------------"
echo "Run this command after setting up Railway PostgreSQL:"
echo ""
echo "  railway connect postgres"
echo "  \\i $(pwd)/local-backup.sql"
echo ""
echo "Or using psql directly:"
echo "  psql \$DATABASE_URL < $BACKUP_FILE"
echo ""
echo "✅ Migration preparation complete!"
