# Paperclip Local Cleanup Plan

## Overview
After migrating to Railway, you can safely remove all local Paperclip installations to free up disk space.

**Total space to free:** ~277MB

---

## Items to Delete

### 1. Paperclip CLI (npm global package)
**Package:** `paperclipai@2026.403.0`
**Location:** `/opt/homebrew/lib/node_modules/paperclipai`
**Size:** ~50MB

**How to remove:**
```bash
npm uninstall -g paperclipai
```

---

### 2. Paperclip Instance Data
**Location:** `~/.paperclip/`
**Size:** ~171MB

**Contains:**
- Instance data: `~/.paperclip/instances/default` (116MB)
  - Database: `db/` (embedded PostgreSQL)
  - Backups: `data/backups/`
  - Logs: `logs/`
  - Storage: `data/storage/`
  - Secrets: `secrets/`
- Plugins: `~/.paperclip/plugins` (55MB)

**How to remove:**
```bash
rm -rf ~/.paperclip
```

**⚠️ Before deleting:**
- Ensure database is migrated to Railway
- Save latest backup: `~/.paperclip/instances/default/data/backups/paperclip-20260407-195154.sql`

---

### 3. Slack Plugin Development Folder
**Location:** `/Users/mikhail/paperclip-plugins/slack`
**Size:** 56MB

**Contains:**
- Source code: `src/`
- Dependencies: `node_modules/` (~50MB)
- Config: `plugin-config.json`, `tsconfig.json`
- Build artifacts

**How to remove:**
```bash
rm -rf /Users/mikhail/paperclip-plugins/slack
# If parent folder is empty:
rmdir /Users/mikhail/paperclip-plugins
```

---

## Before You Delete - Checklist

- [ ] **Railway deployment successful**
  - Paperclip is running on Railway
  - You can access the UI at your Railway URL

- [ ] **Database migrated**
  - All issues, projects, and settings transferred
  - Test that you can see your data in Railway instance

- [ ] **GitHub integration working**
  - `GITHUB_TOKEN` added to Railway environment variables
  - Agents can create issues/PRs

- [ ] **Slack integration working**
  - Webhook URLs updated in Slack app settings
  - Approve/Reject buttons work
  - Notifications are being delivered

- [ ] **Backup saved** (recommended)
  - Latest database backup copied to safe location
  - Or run: `cp ~/.paperclip/instances/default/data/backups/paperclip-20260407-195154.sql ~/Downloads/`

---

## Automated Cleanup

Use the provided script for safe, guided cleanup:

```bash
cd ~/developer/paperclip.agency
./scripts/cleanup-local-paperclip.sh
```

The script will:
1. Check for backups
2. Show what will be deleted
3. Ask for confirmation
4. Uninstall npm package
5. Remove instance data
6. Remove Slack plugin folder
7. Clean up empty parent directories

---

## Manual Cleanup

If you prefer manual removal:

```bash
# 1. Uninstall CLI
npm uninstall -g paperclipai

# 2. Remove instance data
rm -rf ~/.paperclip

# 3. Remove Slack plugin
rm -rf /Users/mikhail/paperclip-plugins/slack
rmdir /Users/mikhail/paperclip-plugins  # if empty
```

---

## What NOT to Delete

**Keep these:**
- ✅ `~/developer/paperclip.agency/` - Your deployment repo
- ✅ GitHub token (you'll need it for Railway)
- ✅ Slack tokens (configured in Railway)
- ✅ Database backup (until you verify Railway works)

---

## Rollback Plan

If something goes wrong with Railway:

1. **Reinstall Paperclip CLI:**
   ```bash
   npm install -g paperclipai@2026.403.0
   ```

2. **Restore from backup:**
   ```bash
   paperclip init
   # Then import your backup SQL file
   ```

3. **Reconfigure Slack plugin:**
   ```bash
   cd /Users/mikhail/paperclip-plugins/slack
   npm install
   # Re-add plugin-config.json
   ```

---

## Post-Cleanup

After cleanup, your Paperclip setup will be:
- ✅ Running on Railway (24/7)
- ✅ Managed via GitHub repo
- ✅ ~277MB of local disk space freed
- ✅ No local dependencies
- ✅ Team can access from anywhere

---

## Questions?

- Check Railway logs: `railway logs`
- Test Railway instance: Visit your Railway URL
- Verify database: `railway connect postgres` → `\dt` to list tables
