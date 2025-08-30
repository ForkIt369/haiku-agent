# 🚀 Quick Manual Setup - 3 Minutes

Your services are running! Here's how to complete the setup:

## 📍 Your Live Services:

| Service | URL | Status |
|---------|-----|--------|
| **n8n** | https://n8n-production-de44.up.railway.app | ✅ Running |
| **UI** | https://forkit369.github.io/haiku-agent/ui/ | ✅ Live |

## 🎯 Step-by-Step Setup:

### 1️⃣ Open n8n (30 seconds)
1. Click here: **https://n8n-production-de44.up.railway.app**
2. You'll see the n8n interface
3. If prompted to create account:
   - Email: your email
   - Password: create a strong password
   - Remember these credentials!

### 2️⃣ Import Workflow (1 minute)
1. Click **"Workflows"** in left sidebar
2. Click **"Add Workflow"** (top right)
3. Select **"Import from File"**
4. Upload this file from the repo: `n8n/workflows/haiku-agent-mvp.json`
5. Click **"Import"**

### 3️⃣ Set OpenRouter API Key (1 minute)
1. In the imported workflow, double-click **"OpenRouter API"** node
2. Click on **"Credentials"** dropdown
3. Click **"Create New"**
4. Add credential:
   - Credential Type: **Header Auth**
   - Name: `OpenRouter API`
   - Header Name: `Authorization`
   - Header Value: `Bearer YOUR_OPENROUTER_KEY`
   - (Replace YOUR_OPENROUTER_KEY with your actual key)
5. Click **"Create"**

### 4️⃣ Activate Workflow (30 seconds)
1. Toggle the **"Active"** switch (top right corner)
2. You'll see **"Workflow activated"**
3. The webhook is now live!

## ✅ Test Everything:

### Option A: Test via UI
1. Open: **https://forkit369.github.io/haiku-agent/ui/**
2. Type a message and press Enter
3. You should get a response!

### Option B: Test via Command
```bash
curl -X POST https://n8n-production-de44.up.railway.app/webhook/haiku-chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello HAIKU!",
    "personality": "BigSis",
    "userId": "test"
  }'
```

## 🎉 That's It! You're Live!

Your HAIKU Agent is now running with:
- 4 personality modes (BigSis, Bro, LilSis, CBO)
- OpenRouter for cost-optimized AI
- Beautiful HAIKU-styled interface
- Conversation memory

## 🚨 Troubleshooting:

**No response from webhook?**
- Check workflow is activated (toggle switch ON)
- Verify OpenRouter credential has your API key
- Check n8n Executions tab for errors

**UI not loading?**
- GitHub Pages can take 2-3 minutes to deploy
- Try: https://forkit369.github.io/haiku-agent/ui/index.html

**Need your OpenRouter key?**
- Get it from: https://openrouter.ai/keys
- You have $5 free credit on signup

## 📊 Monitor Usage:
- **n8n Executions**: See all requests and responses
- **OpenRouter Dashboard**: Track API usage and costs
- **Railway Metrics**: Monitor performance

---

**Done in 3 minutes!** Your HAIKU Agent is ready to chat. 🤖