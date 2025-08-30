# Quick n8n Setup Commands

## 1. Find Your n8n URL

Check your Railway dashboard or run:
```bash
# If you deployed via template, it might be something like:
# https://n8n-production-xxxx.up.railway.app
```

## 2. Test Your n8n is Running

```bash
# Replace YOUR_N8N_URL with your actual URL
curl -I YOUR_N8N_URL

# Should return HTTP 200 or 401 (needs auth)
```

## 3. Manual Workflow Import

Since n8n doesn't have a direct CLI import, you'll need to:

1. **Open n8n in browser**
   - Go to your Railway n8n URL
   - Login with username: `admin` password: `changeme123`

2. **Import the workflow**
   - Click "Workflows" in sidebar
   - Click "Add Workflow" → "Import from File"
   - Select: `n8n/workflows/haiku-agent-mvp.json`
   - Click "Import"

3. **Activate the workflow**
   - Open the imported workflow
   - Toggle "Active" switch (top right)
   - Copy the webhook URL shown

## 4. Update UI with Your Webhook URL

```bash
# Replace YOUR_N8N_URL with your actual URL
export N8N_URL="YOUR_N8N_URL"

# Update the UI file
sed -i '' "s|window.WEBHOOK_URL = '.*'|window.WEBHOOK_URL = '$N8N_URL/webhook/haiku-chat'|" ui/app.js

# Commit and push
git add ui/app.js
git commit -m "Update webhook URL to Railway n8n instance"
git push
```

## 5. Test the Webhook

```bash
# Replace YOUR_N8N_URL with your actual URL
curl -X POST YOUR_N8N_URL/webhook/haiku-chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello HAIKU!",
    "personality": "BigSis",
    "userId": "test"
  }'
```

## 6. Deploy UI to GitHub Pages

```bash
# Enable GitHub Pages
gh repo edit --enable-pages

# Set pages source (might need to do in UI)
# Go to: https://github.com/ForkIt369/haiku-agent/settings/pages
# Source: Deploy from branch
# Branch: main
# Folder: / (root)

# Your UI will be at:
# https://forkit369.github.io/haiku-agent/ui/
```

## Alternative: Deploy UI to Vercel

```bash
cd ui
npx vercel --prod

# Follow prompts to deploy
# Your UI will get a vercel.app URL
```

## Local Testing

```bash
# Test UI locally
cd ui
python3 -m http.server 8000

# Open: http://localhost:8000
```