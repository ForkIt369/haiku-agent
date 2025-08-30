# HAIKU Agent Setup Guide

## 🚀 Quick Start (10 minutes)

### Prerequisites
- Git installed
- Node.js 18+
- OpenRouter API key ($5 free credit on signup)
- Railway account (free tier available)
- Vercel account (optional, for UI hosting)

### 1. Clone & Configure

```bash
# Clone repository
git clone https://github.com/yourusername/haiku-agent.git
cd haiku-agent

# Copy environment template
cp .env.example .env

# Edit .env with your values
nano .env
```

### 2. Get OpenRouter API Key

1. Visit [OpenRouter.ai](https://openrouter.ai)
2. Sign up (get $5 free credit)
3. Go to Keys → Create New Key
4. Copy key to `.env` file

### 3. Deploy to Railway

```bash
# Run deployment script
./scripts/deploy.sh

# Choose option 1 for full deployment
```

Or manually:

```bash
# Install Railway CLI
curl -fsSL https://railway.app/install.sh | sh

# Login and create project
railway login
railway link

# Set environment variables
railway variables --set "OPENROUTER_API_KEY=your-key"
railway variables --set "N8N_BASIC_AUTH_USER=admin"
railway variables --set "N8N_BASIC_AUTH_PASSWORD=secure-password"

# Deploy
railway up
```

### 4. Import Workflow

1. Open your n8n instance: `https://your-app.railway.app`
2. Login with credentials from `.env`
3. Go to **Workflows** → **Import**
4. Upload `n8n/workflows/haiku-agent-mvp.json`
5. Click **Activate** to enable the workflow

### 5. Deploy UI (Optional)

```bash
cd ui

# Update webhook URL in app.js
# Replace 'your-n8n.railway.app' with your Railway URL

# Deploy to Vercel
vercel --prod
```

Or use GitHub Pages:

```bash
# Commit and push to GitHub
git add .
git commit -m "Initial HAIKU Agent"
git push origin main

# Enable GitHub Pages in repo settings
# Source: /ui directory
```

## 🎮 Local Development

### Using Docker Compose

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

Access:
- n8n: http://localhost:5678
- UI: Open `ui/index.html` in browser

### Manual Setup

```bash
# Install n8n globally
npm install -g n8n

# Start n8n
n8n start

# In another terminal, serve UI
cd ui
python -m http.server 8000
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `OPENROUTER_API_KEY` | Your OpenRouter API key | Required |
| `OPENROUTER_DEFAULT_MODEL` | Default AI model | `openai/gpt-4o-mini` |
| `N8N_WEBHOOK_URL` | Webhook endpoint | Auto-generated |
| `N8N_BASIC_AUTH_USER` | n8n username | `admin` |
| `N8N_BASIC_AUTH_PASSWORD` | n8n password | Required |
| `DEFAULT_PERSONALITY` | Starting personality | `BigSis` |
| `DAILY_COST_LIMIT` | Daily spending cap | `$5.00` |
| `MONTHLY_COST_LIMIT` | Monthly spending cap | `$100.00` |

### Model Selection

Cost-optimized defaults:
- **Simple queries**: Gemini Flash 2.0 ($0.04/1M tokens)
- **Standard tasks**: GPT-4o-mini ($0.15/1M tokens)
- **Complex reasoning**: Claude 3.5 Sonnet ($3.00/1M tokens)

### Personality Modes

| Personality | Color | Behavior |
|-------------|-------|----------|
| **BigSis** | #00A1F1 | Analytical, thorough, protective |
| **Bro** | #FE5F00 | Direct, action-oriented, efficient |
| **LilSis** | #7E3AF2 | Creative, enthusiastic, playful |
| **CBO** | #3EB85F | Strategic, growth-focused, data-driven |

## 🧪 Testing

### Test Webhook

```bash
# Test with curl
curl -X POST https://your-n8n.railway.app/webhook/haiku-chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello, can you help me?",
    "userId": "test-user",
    "personality": "BigSis"
  }'
```

### Test UI Locally

1. Update `window.WEBHOOK_URL` in `ui/app.js`
2. Open `ui/index.html` in browser
3. Send test messages

## 📊 Monitoring

### View Logs

```bash
# Railway logs
railway logs

# Docker logs
docker-compose logs -f n8n
```

### Track Costs

Monitor in n8n:
1. Go to **Executions**
2. Check workflow runs
3. View metadata for cost tracking

## 🚨 Troubleshooting

### Common Issues

**CORS errors**
- Add your domain to n8n webhook settings
- Use HTTPS for production

**Webhook not responding**
- Check workflow is activated
- Verify webhook URL matches
- Check authentication settings

**High costs**
- Adjust model routing rules
- Set stricter cost limits
- Use caching for repeated queries

**Memory not persisting**
- Check Redis connection
- Verify memory buffer node settings
- Increase memory limit if needed

## 🔐 Security

### Production Checklist

- [ ] Change default passwords
- [ ] Use HTTPS only
- [ ] Enable rate limiting
- [ ] Rotate API keys regularly
- [ ] Monitor usage logs
- [ ] Set cost alerts
- [ ] Backup workflows
- [ ] Use environment secrets

### Railway Security

```bash
# Set sensitive variables
railway variables --set "OPENROUTER_API_KEY=$KEY" --secret
railway variables --set "N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)"
```

## 📚 Resources

- [OpenRouter Documentation](https://openrouter.ai/docs)
- [n8n Documentation](https://docs.n8n.io)
- [Railway Guide](https://docs.railway.app)
- [HAIKU Design System](../docs/HAIKU-DESIGN-SYSTEM.md)

## 💡 Next Steps

1. **Customize personalities** in workflow
2. **Add more models** to routing logic
3. **Implement caching** for common queries
4. **Add analytics** tracking
5. **Create specialized workflows** for different use cases

## 🆘 Support

- GitHub Issues: [Report bugs](https://github.com/yourusername/haiku-agent/issues)
- Discord: Join our community
- Email: support@example.com

---

Built with 💙 using the HAIKU Design System