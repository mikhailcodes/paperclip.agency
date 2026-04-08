# Paperclip Agency Deployment

This repository manages the deployment of Paperclip to Railway for production use.

## Features

- **GitHub Integration**: Agents can create issues and PRs
- **Slack Integration**: Approvals and notifications via Slack
- **PostgreSQL Database**: Persistent storage on Railway
- **24/7 Uptime**: Always available for team collaboration

---

## Deployment Steps

### 1. Prerequisites

- Railway account: https://railway.app
- GitHub token with `repo` and `project` scopes
- Slack bot token (from Slack plugin setup)

### 2. Deploy to Railway

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Add PostgreSQL database
railway add --database postgresql

# Deploy
railway up
```

### 3. Configure Environment Variables

Go to Railway dashboard → Your Project → Variables and add:

**Required:**
```
PAPERCLIP_AGENT_JWT_SECRET=<your-jwt-secret>
GITHUB_TOKEN=<your-github-token>
```

**Optional (Slack):**
```
SLACK_BOT_TOKEN=<from-plugin-config>
SLACK_SIGNING_SECRET=<from-plugin-config>
```

Railway will automatically set:
- `DATABASE_URL` (when you add PostgreSQL)
- `PORT` (defaults to 3100)

### 4. Get Your Railway URL

After deployment, Railway provides a URL like:
```
https://paperclip-agency-production.up.railway.app
```

### 5. Update Slack Webhooks

In your Slack app settings (https://api.slack.com/apps), update:

**Interactivity & Shortcuts:**
```
https://your-railway-url/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slack-interactivity
```

**Slash Commands:**
```
https://your-railway-url/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slash-command
```

**Event Subscriptions:**
```
https://your-railway-url/api/webhooks/2790cdda-de67-4ddd-b003-251ca4e0e4d5/slack-events
```

### 6. Migrate Your Database

```bash
# Export from local instance
pg_dump -h localhost -p 54329 -U postgres paperclip > backup.sql

# Import to Railway (get connection details from Railway dashboard)
psql $DATABASE_URL < backup.sql
```

---

## Adding Custom Code

You can extend Paperclip by:

1. **Custom Plugins**: Add to `plugins/` directory
2. **Custom Agents**: Add to `agents/` directory
3. **Configuration**: Modify `config.json` for your needs

After changes, commit and push:
```bash
git add .
git commit -m "feat: add custom plugin"
git push
```

Railway will automatically redeploy.

---

## Environment Variables Reference

See [.env.example](.env.example) for all available environment variables.

---

## Troubleshooting

**Database connection issues:**
- Check that PostgreSQL addon is added in Railway
- Verify `DATABASE_URL` is set in Railway dashboard

**Slack webhooks not working:**
- Ensure Railway URL is public (not localhost)
- Check webhook URLs in Slack app settings
- Verify `SLACK_BOT_TOKEN` and `SLACK_SIGNING_SECRET` are set

**GitHub integration not working:**
- Verify `GITHUB_TOKEN` has correct scopes
- Check token hasn't expired
- Test token with: `curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user`

---

## Useful Commands

```bash
# View logs
railway logs

# Open in browser
railway open

# Connect to database
railway connect postgres

# Restart service
railway restart
```

---

## Support

- Paperclip Docs: https://docs.paperclip.ai
- Railway Docs: https://docs.railway.app
- Issues: https://github.com/mikhailcodes/paperclip.agency/issues
