# Railway Deployment Instructions

## 🚀 Quick n8n Setup on Railway

Since Railway doesn't directly support Docker Compose, we'll use Railway's n8n template:

### Option 1: Use Railway Template (Recommended)

1. **Deploy n8n Template**
   - Go to: https://railway.app/template/n8n
   - Click "Deploy Now"
   - This creates a PostgreSQL database and n8n service automatically

2. **Configure Environment Variables**
   After deployment, go to your service settings and add:
   ```
   OPENROUTER_API_KEY=your-key-here
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=your-secure-password
   WEBHOOK_URL=https://your-service.railway.app
   ```

3. **Get Your n8n URL**
   - Go to Settings → Networking
   - Generate Domain (or use custom domain)
   - Your n8n will be at: `https://your-app.railway.app`

### Option 2: Manual Docker Service

1. **Create New Service in Railway**
   ```bash
   railway service create n8n
   ```

2. **Add PostgreSQL Database**
   ```bash
   railway add postgresql
   ```

3. **Set Variables**
   ```bash
   railway variables --set "N8N_HOST=0.0.0.0"
   railway variables --set "N8N_PORT=5678"
   railway variables --set "N8N_PROTOCOL=https"
   railway variables --set "DB_TYPE=postgresdb"
   railway variables --set "DB_POSTGRESDB_HOST=$PGHOST"
   railway variables --set "DB_POSTGRESDB_PORT=$PGPORT"
   railway variables --set "DB_POSTGRESDB_DATABASE=$PGDATABASE"
   railway variables --set "DB_POSTGRESDB_USER=$PGUSER"
   railway variables --set "DB_POSTGRESDB_PASSWORD=$PGPASSWORD"
   ```

4. **Deploy from Docker Hub**
   - In Railway UI, go to Settings
   - Set Docker Image: `n8nio/n8n:latest`
   - Deploy

## 📥 Import Workflow

Once n8n is running:

1. **Access n8n**
   - Go to your Railway URL
   - Login with your credentials

2. **Import Workflow**
   - Click "Workflows" → "Import from File"
   - Upload: `n8n/workflows/haiku-agent-mvp.json`
   - Click "Save"

3. **Activate Workflow**
   - Open the imported workflow
   - Click "Activate" toggle
   - Note the webhook URL shown

4. **Update UI**
   - Edit `ui/app.js`
   - Update `window.WEBHOOK_URL` with your webhook URL
   - Commit and push changes

## 🧪 Test Your Setup

1. **Test Webhook**
   ```bash
   curl -X POST https://your-n8n.railway.app/webhook/haiku-chat \
     -H "Content-Type: application/json" \
     -d '{
       "message": "Hello!",
       "personality": "BigSis",
       "userId": "test"
     }'
   ```

2. **Check Execution**
   - Go to n8n → Executions
   - You should see your test message

## 🌐 Deploy UI

### Option A: GitHub Pages
1. Go to GitHub repo settings
2. Enable Pages from `/ui` folder
3. Your UI: `https://username.github.io/haiku-agent/ui`

### Option B: Vercel
```bash
cd ui
vercel --prod
```

### Option C: Local Testing
```bash
cd ui
python -m http.server 8000
# Open http://localhost:8000
```

## 🔧 Troubleshooting

**n8n not starting?**
- Check Railway logs
- Ensure PostgreSQL is connected
- Verify environment variables

**Webhook not working?**
- Workflow must be activated
- Check webhook URL matches
- Verify CORS settings

**High memory usage?**
- Set `EXECUTIONS_DATA_PRUNE=true`
- Set `EXECUTIONS_DATA_MAX_AGE=336` (2 weeks)

## 📝 Your Deployment Details

Based on your current setup:
- **Railway Project**: divine-acceptance
- **Service Name**: haiku-agent
- **Domain**: https://haiku-agent-production.up.railway.app

## Next Steps

1. Use Railway's n8n template for easiest setup
2. Import the workflow from this repo
3. Update webhook URL in UI
4. Deploy UI to Vercel or GitHub Pages