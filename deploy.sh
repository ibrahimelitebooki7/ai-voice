#!/bin/bash

echo "🚀 DEPLOYING AI VOICE AGENT BACKEND"
echo "===================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo -e "${RED}Error: wrangler not found. Installing...${NC}"
    npm install -g wrangler
fi

# Login to Cloudflare
echo -e "${YELLOW}Step 1: Login to Cloudflare...${NC}"
wrangler login

# Deploy worker
echo -e "${YELLOW}Step 2: Deploying worker...${NC}"
wrangler deploy

echo -e "${YELLOW}Step 3: Setting up secrets...${NC}"
echo -e "${GREEN}IMPORTANT: You need your Retell API credentials:${NC}"
echo "1. Go to https://retellai.com"
echo "2. Sign up and get API Key & Agent ID"
echo ""

# Set Retell API Key
echo -e "${YELLOW}Enter your Retell API Key:${NC}"
read -r retell_api_key
wrangler secret put RETELL_API_KEY <<< "$retell_api_key"

# Set Retell Agent ID
echo -e "${YELLOW}Enter your Retell Agent ID:${NC}"
read -r retell_agent_id
wrangler secret put RETELL_AGENT_ID <<< "$retell_agent_id"

# Get worker URL
echo -e "${YELLOW}Step 4: Getting worker URL...${NC}"
worker_url=$(wrangler whoami | grep -o 'workers\.dev.*' | sed 's/\.$//' | head -1)

if [ -z "$worker_url" ]; then
    worker_url="ai-voice-agent-backend.workers.dev"
fi

echo ""
echo -e "${GREEN}✅ BACKEND DEPLOYED SUCCESSFULLY!${NC}"
echo ""
echo -e "${YELLOW}Your Worker URL:${NC}"
echo -e "  ${GREEN}https://${worker_url}${NC}"
echo ""
echo -e "${YELLOW}API Endpoints:${NC}"
echo "  POST /api/create-call"
echo "  GET  /health"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Update frontend with this URL:"
echo "   Change line in index.html:"
echo "   const WORKER_URL = 'https://${worker_url}';"
echo ""
echo "2. Test backend:"
echo "   curl https://${worker_url}/health"
echo ""
echo "3. Deploy frontend to Cloudflare Pages"
