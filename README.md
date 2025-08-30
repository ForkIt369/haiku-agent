# 🤖 HAIKU Agent - Context-Aware AI Assistant

> A personality-driven AI assistant built with n8n, OpenRouter, and the HAIKU Design System. Deploy in 10 minutes to Railway.

<div align="center">

![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Deploy](https://img.shields.io/badge/deploy-Railway-purple.svg)
![UI](https://img.shields.io/badge/UI-HAIKU-orange.svg)

[Demo](https://haiku-agent.vercel.app) • [Docs](./docs) • [Deploy](#-quick-deploy) • [Roadmap](./docs/ITERATION-ROADMAP.md)

</div>

## ✨ Features

### 🎭 4 Personality Modes
- **BigSis** (Blue #00A1F1) - Analytical, thorough, protective guidance
- **Bro** (Orange #FE5F00) - Direct, action-oriented, efficient solutions  
- **LilSis** (Purple #7E3AF2) - Creative, enthusiastic, playful interactions
- **CBO** (Green #3EB85F) - Strategic, growth-focused, data-driven insights

### 💰 Cost-Optimized Routing
- Simple queries → Gemini Flash 2.0 ($0.04/1M tokens)
- Standard tasks → GPT-4o-mini ($0.15/1M tokens)
- Complex reasoning → Claude 3.5 Sonnet ($3.00/1M tokens)

### 🎨 HAIKU Design System
- **4-3-2-1 Framework**: 4 pillars, 3 constraints, 2 options, 1 base unit
- **60-30-10 Rule**: Perfect visual balance in colors, layout, and content
- **8px Grid System**: Consistent spacing and alignment
- **BDS Colors**: Agent-specific personality colors

## 🚀 Quick Deploy

### One-Command Deploy
```bash
# Clone and deploy
git clone https://github.com/yourusername/haiku-agent.git
cd haiku-agent
./scripts/deploy.sh
```

### Manual Setup (10 minutes)
```bash
# 1. Clone this repo
git clone https://github.com/yourusername/haiku-agent.git
cd haiku-agent

# 2. Configure environment
cp .env.example .env
# Edit .env with your OpenRouter API key

# 3. Deploy n8n to Railway
railway login
railway link
railway up

# 4. Deploy UI to Vercel
cd ui
vercel --prod

# Done! Your agent is live 🎉
```

## 🏗️ Architecture

```
User → Web UI → n8n Webhook → OpenRouter → AI Model → Response
         ↑                         ↓
         └─────── Memory ←─────────┘
```

## 📁 Project Structure

```
haiku-agent/
├── /n8n/          # Workflow files
├── /ui/           # Web interface
├── /api/          # Backend utilities
├── /docs/         # Documentation
└── /scripts/      # Automation
```

## ⚙️ Configuration

### Required Environment Variables

```env
# OpenRouter
OPENROUTER_API_KEY=sk-or-v1-xxxxx

# n8n (Railway provides these)
N8N_WEBHOOK_URL=https://your-n8n.railway.app/webhook/

# Optional
DEFAULT_MODEL=openai/gpt-4o-mini
MAX_MEMORY_SIZE=20
```

## 🎨 Design System

Following HAIKU principles:
- **4 Pillars**: Constraint, Ratio, Harmony, Flow
- **3 Constraints**: Per element maximum
- **2 Options**: Binary choices
- **1 Base Unit**: 8px grid

Color Palette:
- BigSis: `#00A1F1` (Trust/Analysis)
- Bro: `#FE5F00` (Action/Energy)
- LilSis: `#7E3AF2` (Creative/Play)
- CBO: `#3EB85F` (Growth/Strategy)

## 🚀 Deployment

### Railway (n8n)

1. Connect GitHub repo
2. Add environment variables
3. Deploy with one click

### Vercel (UI)

1. Import GitHub repo
2. Set root directory to `/ui`
3. Deploy

## 📊 Costs

Estimated monthly costs:
- **Development**: ~$5 (testing)
- **Production**: ~$15-30 (1000 daily messages)
- **Infrastructure**: Free tier eligible

## 🔄 Iteration Plan

- [x] Week 1: MVP deployment
- [ ] Week 2: Agent personalities
- [ ] Week 3: Advanced routing
- [ ] Week 4: Team features

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

## 📝 License

MIT - Use freely, build amazing things!

## 🙏 Credits

Built with:
- [n8n](https://n8n.io) - Workflow automation
- [OpenRouter](https://openrouter.ai) - AI model access
- [Railway](https://railway.app) - Infrastructure
- [Vercel](https://vercel.com) - Frontend hosting

---

**Ready to build?** Start with the [Setup Guide](docs/SETUP.md) →