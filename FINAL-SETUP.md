# 🎉 HAIKU Agent - Final Setup Steps

## ✅ What's Already Done:
- ✅ n8n is running at: **https://n8n-production-de44.up.railway.app**
- ✅ UI is live at: **https://forkit369.github.io/haiku-agent/ui/**
- ✅ Webhook URL is configured in the UI
- ✅ All environment variables are set

## 📋 Manual Steps to Complete (5 minutes):

### 1. Access Your n8n Instance
- Open: **https://n8n-production-de44.up.railway.app**
- Login with:
  - Username: `admin`
  - Password: `changeme123`

### 2. Import the Workflow
1. Click **"Workflows"** in the left sidebar
2. Click **"Add Workflow"** button (top right)
3. Select **"Import from File"**
4. Choose file: `n8n/workflows/haiku-agent-mvp.json` from this repo
5. Click **"Import"**

### 3. Configure OpenRouter in the Workflow
1. Open the imported workflow
2. Double-click the **"OpenRouter"** node
3. Click on **"Credentials"**
4. Create new credential:
   - Name: `OpenRouter API`
   - API Key: `your-openrouter-key` (the one you set in Railway)
5. Save the credential

### 4. Activate the Workflow
1. In the workflow editor, toggle the **"Active"** switch (top right)
2. You should see: **"Workflow activated"**
3. The webhook URL will be shown: `https://n8n-production-de44.up.railway.app/webhook/haiku-chat`

### 5. Test Everything

#### Test via Command Line:
```bash
curl -X POST https://n8n-production-de44.up.railway.app/webhook/haiku-chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello HAIKU!",
    "personality": "BigSis",
    "userId": "test-user"
  }'
```

#### Test via UI:
1. Open: **https://forkit369.github.io/haiku-agent/ui/**
2. Select a personality (BigSis, Bro, LilSis, or CBO)
3. Type a message and press Enter
4. You should get a response!

## 🚨 Troubleshooting:

### If webhook returns 404:
- Make sure workflow is **activated** (toggle switch)
- Check webhook node is named exactly: `haiku-chat`

### If no response:
- Check n8n Executions tab for errors
- Verify OpenRouter credential is set
- Check your OpenRouter API key has credits

### If UI doesn't load:
- Wait 2-3 minutes for GitHub Pages to deploy
- Try hard refresh (Ctrl+Shift+R or Cmd+Shift+R)
- Check browser console for errors

## 🎯 Quick Test Commands:

```bash
# Test n8n is running
curl -I https://n8n-production-de44.up.railway.app

# Test with BigSis personality
curl -X POST https://n8n-production-de44.up.railway.app/webhook/haiku-chat \
  -H "Content-Type: application/json" \
  -d '{"message": "What is 2+2?", "personality": "BigSis", "userId": "test"}'

# Test with Bro personality  
curl -X POST https://n8n-production-de44.up.railway.app/webhook/haiku-chat \
  -H "Content-Type: application/json" \
  -d '{"message": "How do I get stronger?", "personality": "Bro", "userId": "test"}'
```

## 📊 Monitor Your Usage:

1. **In n8n**: Go to "Executions" to see all requests
2. **In OpenRouter**: Check dashboard for API usage
3. **In Railway**: Monitor metrics for performance

## 🚀 What's Next?

Check out the [Iteration Roadmap](docs/ITERATION-ROADMAP.md) for planned features:
- v0.2.0: Redis memory persistence
- v0.3.0: Smart model routing
- v0.4.0: Enhanced UI with reactions
- v0.5.0: Tool integration (search, calculator)

## 🔗 Your Live Services:

| Service | URL | Status |
|---------|-----|--------|
| **n8n Workflow** | https://n8n-production-de44.up.railway.app | ✅ Running |
| **UI Interface** | https://forkit369.github.io/haiku-agent/ui/ | ✅ Live |
| **GitHub Repo** | https://github.com/ForkIt369/haiku-agent | ✅ Public |
| **Railway Project** | divine-acceptance | ✅ Active |

---

**Need help?** Check the workflow in n8n's Executions tab to see what's happening with each request.