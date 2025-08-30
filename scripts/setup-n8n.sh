#!/bin/bash

# HAIKU Agent - n8n Setup Script
# This script imports the workflow and configures n8n

set -e

echo "🚀 HAIKU Agent - n8n Setup"
echo "=========================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get n8n URL from user
echo -e "${BLUE}Please enter your n8n Railway URL:${NC}"
echo "Example: https://your-app.railway.app"
read -r N8N_URL

# Get credentials
echo -e "${BLUE}Enter your n8n username (default: admin):${NC}"
read -r N8N_USER
N8N_USER=${N8N_USER:-admin}

echo -e "${BLUE}Enter your n8n password:${NC}"
read -rs N8N_PASSWORD
echo

# Remove trailing slash if present
N8N_URL=${N8N_URL%/}

# Test connection
echo -e "${BLUE}Testing n8n connection...${NC}"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "$N8N_USER:$N8N_PASSWORD" "$N8N_URL/rest/workflows")

if [ "$STATUS" -eq 200 ] || [ "$STATUS" -eq 401 ]; then
    echo -e "${GREEN}✓ n8n is accessible${NC}"
else
    echo -e "${RED}✗ Cannot connect to n8n (HTTP $STATUS)${NC}"
    echo "Please check your URL and try again"
    exit 1
fi

# Read workflow file
WORKFLOW_FILE="n8n/workflows/haiku-agent-mvp.json"
if [ ! -f "$WORKFLOW_FILE" ]; then
    echo -e "${RED}✗ Workflow file not found: $WORKFLOW_FILE${NC}"
    exit 1
fi

# Import workflow via API
echo -e "${BLUE}Importing HAIKU Agent workflow...${NC}"

# Create workflow
RESPONSE=$(curl -s -X POST "$N8N_URL/rest/workflows" \
  -u "$N8N_USER:$N8N_PASSWORD" \
  -H "Content-Type: application/json" \
  -d @"$WORKFLOW_FILE")

# Check if import was successful
if echo "$RESPONSE" | grep -q '"id"'; then
    WORKFLOW_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo -e "${GREEN}✓ Workflow imported successfully (ID: $WORKFLOW_ID)${NC}"
    
    # Activate workflow
    echo -e "${BLUE}Activating workflow...${NC}"
    curl -s -X PATCH "$N8N_URL/rest/workflows/$WORKFLOW_ID" \
      -u "$N8N_USER:$N8N_PASSWORD" \
      -H "Content-Type: application/json" \
      -d '{"active": true}' > /dev/null
    
    echo -e "${GREEN}✓ Workflow activated${NC}"
    
    # Display webhook URL
    WEBHOOK_URL="$N8N_URL/webhook/haiku-chat"
    echo ""
    echo -e "${GREEN}🎉 Setup Complete!${NC}"
    echo ""
    echo -e "${BLUE}Your webhook URL is:${NC}"
    echo -e "${YELLOW}$WEBHOOK_URL${NC}"
    echo ""
    
    # Update UI file
    echo -e "${BLUE}Updating UI with webhook URL...${NC}"
    sed -i.bak "s|window.WEBHOOK_URL = '.*'|window.WEBHOOK_URL = '$WEBHOOK_URL'|" ui/app.js
    rm ui/app.js.bak
    echo -e "${GREEN}✓ UI updated${NC}"
    
    # Test webhook
    echo ""
    echo -e "${BLUE}Testing webhook...${NC}"
    TEST_RESPONSE=$(curl -s -X POST "$WEBHOOK_URL" \
      -H "Content-Type: application/json" \
      -d '{
        "message": "Hello, testing HAIKU Agent!",
        "personality": "BigSis",
        "userId": "test-user"
      }')
    
    if echo "$TEST_RESPONSE" | grep -q "message"; then
        echo -e "${GREEN}✓ Webhook is working!${NC}"
        echo "Response: $TEST_RESPONSE"
    else
        echo -e "${YELLOW}⚠ Webhook test returned unexpected response${NC}"
        echo "Please check the workflow in n8n"
    fi
    
    # Commit changes
    echo ""
    echo -e "${BLUE}Committing changes...${NC}"
    git add ui/app.js
    git commit -m "Update webhook URL to $N8N_URL" || true
    git push || true
    
    echo ""
    echo -e "${GREEN}✅ All done!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Open n8n at: $N8N_URL"
    echo "2. Check the workflow is active"
    echo "3. Deploy UI to GitHub Pages or Vercel"
    echo "4. Test the chat interface"
    
else
    echo -e "${RED}✗ Failed to import workflow${NC}"
    echo "Response: $RESPONSE"
    echo ""
    echo "Please import manually:"
    echo "1. Open n8n at: $N8N_URL"
    echo "2. Go to Workflows → Import"
    echo "3. Upload: n8n/workflows/haiku-agent-mvp.json"
    echo "4. Activate the workflow"
fi