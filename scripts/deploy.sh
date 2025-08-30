#!/bin/bash

# HAIKU Agent Deployment Script
# Deploys n8n to Railway and UI to Vercel

set -e

echo "🚀 HAIKU Agent Deployment"
echo "========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check prerequisites
check_prerequisites() {
    echo -e "${BLUE}Checking prerequisites...${NC}"
    
    # Check Railway CLI
    if ! command -v railway &> /dev/null; then
        echo -e "${RED}Railway CLI not found. Installing...${NC}"
        curl -fsSL https://railway.app/install.sh | sh
    fi
    
    # Check Vercel CLI
    if ! command -v vercel &> /dev/null; then
        echo -e "${RED}Vercel CLI not found. Installing...${NC}"
        npm i -g vercel
    fi
    
    # Check jq
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}jq not found. Install it for JSON validation.${NC}"
    fi
    
    echo -e "${GREEN}✓ Prerequisites checked${NC}"
}

# Setup environment variables
setup_env() {
    echo -e "${BLUE}Setting up environment variables...${NC}"
    
    if [ ! -f .env ]; then
        cp .env.example .env
        echo -e "${YELLOW}Please edit .env file with your values${NC}"
        echo "Press enter when ready..."
        read
    fi
    
    source .env
    echo -e "${GREEN}✓ Environment variables loaded${NC}"
}

# Deploy n8n to Railway
deploy_n8n() {
    echo -e "${BLUE}Deploying n8n to Railway...${NC}"
    
    cd n8n
    
    # Login to Railway if needed
    if ! railway whoami &> /dev/null; then
        echo -e "${YELLOW}Please login to Railway:${NC}"
        railway login
    fi
    
    # Link or create project
    if [ ! -f .railway ]; then
        echo -e "${YELLOW}Creating new Railway project...${NC}"
        railway link
    fi
    
    # Set environment variables
    echo -e "${BLUE}Setting Railway variables...${NC}"
    railway variables --set "OPENROUTER_API_KEY=$OPENROUTER_API_KEY"
    railway variables --set "N8N_BASIC_AUTH_USER=$N8N_BASIC_AUTH_USER"
    railway variables --set "N8N_BASIC_AUTH_PASSWORD=$N8N_BASIC_AUTH_PASSWORD"
    railway variables --set "N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY"
    
    # Deploy
    railway up
    
    # Get deployment URL
    RAILWAY_URL=$(railway status --json | jq -r '.url')
    echo -e "${GREEN}✓ n8n deployed to: $RAILWAY_URL${NC}"
    
    cd ..
}

# Deploy UI to Vercel
deploy_ui() {
    echo -e "${BLUE}Deploying UI to Vercel...${NC}"
    
    cd ui
    
    # Update webhook URL in app.js
    if [ ! -z "$RAILWAY_URL" ]; then
        sed -i.bak "s|https://your-n8n.railway.app|$RAILWAY_URL|g" app.js
        rm app.js.bak
    fi
    
    # Deploy to Vercel
    vercel --prod
    
    cd ..
    
    echo -e "${GREEN}✓ UI deployed to Vercel${NC}"
}

# Import workflows
import_workflows() {
    echo -e "${BLUE}Importing workflows to n8n...${NC}"
    
    if [ ! -z "$RAILWAY_URL" ]; then
        echo -e "${YELLOW}Please import workflows manually:${NC}"
        echo "1. Open n8n: $RAILWAY_URL"
        echo "2. Login with your credentials"
        echo "3. Go to Workflows > Import"
        echo "4. Upload: n8n/workflows/haiku-agent-mvp.json"
        echo "5. Activate the workflow"
        echo ""
        echo "Press enter when complete..."
        read
    fi
    
    echo -e "${GREEN}✓ Workflows imported${NC}"
}

# Main deployment flow
main() {
    echo ""
    echo "Choose deployment option:"
    echo "1) Full deployment (n8n + UI)"
    echo "2) n8n only (Railway)"
    echo "3) UI only (Vercel)"
    echo "4) Local development (Docker)"
    echo ""
    read -p "Enter choice [1-4]: " choice
    
    case $choice in
        1)
            check_prerequisites
            setup_env
            deploy_n8n
            deploy_ui
            import_workflows
            ;;
        2)
            check_prerequisites
            setup_env
            deploy_n8n
            import_workflows
            ;;
        3)
            check_prerequisites
            setup_env
            deploy_ui
            ;;
        4)
            echo -e "${BLUE}Starting local development...${NC}"
            docker-compose up -d
            echo -e "${GREEN}✓ Local environment running at http://localhost:5678${NC}"
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}🎉 Deployment complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Test the webhook endpoint"
    echo "2. Configure personality responses"
    echo "3. Monitor usage and costs"
    echo "4. Iterate based on feedback"
}

# Run main function
main