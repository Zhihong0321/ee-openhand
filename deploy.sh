#!/bin/bash
# OpenHands Railway Deployment Script with KIMI Support

set -e

echo "========================================="
echo "OpenHands Railway Deployment Script"
echo "========================================="
echo ""
echo "🤖 Optimized for KIMI (Moonshot AI)"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${YELLOW}Railway CLI not found. Installing...${NC}"
    npm install -g @railway/cli
fi

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo -e "${YELLOW}Please login to Railway first:${NC}"
    railway login
fi

echo -e "${GREEN}Step 1: Linking to Railway project...${NC}"
railway link

echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}LLM Provider Selection${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo "Select your LLM provider:"
echo "1) KIMI (Moonshot AI) - Recommended for coding"
echo "2) OpenAI"
echo "3) Anthropic Claude"
echo "4) DeepSeek"
echo "5) Custom (OpenAI-compatible)"
echo ""

read -p "Enter your choice (1-5): " provider_choice

case $provider_choice in
    1)
        echo -e "${GREEN}Configuring for KIMI (Moonshot AI)...${NC}"
        llm_base_url="https://api.moonshot.cn/v1"
        
        echo ""
        echo "Select KIMI Model:"
        echo "1) kimi-k2-turbo-preview - Fast, 256K context (Recommended)"
        echo "2) kimi-k2 - High quality, 256K context"
        echo "3) kimi-k1.5 - General purpose, 128K context"
        read -p "Enter choice (1-3, default: 1): " kimi_model_choice
        
        case $kimi_model_choice in
            2) llm_model="kimi-k2" ;;
            3) llm_model="kimi-k1.5" ;;
            *) llm_model="kimi-k2-turbo-preview" ;;
        esac
        
        echo ""
        echo -e "${YELLOW}Get your API key from: https://platform.moonshot.cn${NC}"
        read -sp "Enter your KIMI API Key (sk-...): " llm_api_key
        echo ""
        ;;
        
    2)
        echo -e "${GREEN}Configuring for OpenAI...${NC}"
        llm_base_url="https://api.openai.com/v1"
        read -p "Enter model (default: gpt-4o): " llm_model
        llm_model=${llm_model:-gpt-4o}
        read -sp "Enter your OpenAI API Key (sk-...): " llm_api_key
        echo ""
        ;;
        
    3)
        echo -e "${GREEN}Configuring for Anthropic Claude...${NC}"
        llm_base_url=""
        read -p "Enter model (default: claude-3-5-sonnet-20241022): " llm_model
        llm_model=${llm_model:-claude-3-5-sonnet-20241022}
        read -sp "Enter your Anthropic API Key (sk-ant-...): " llm_api_key
        echo ""
        ;;
        
    4)
        echo -e "${GREEN}Configuring for DeepSeek...${NC}"
        llm_base_url="https://api.deepseek.com/v1"
        read -p "Enter model (default: deepseek-chat): " llm_model
        llm_model=${llm_model:-deepseek-chat}
        read -sp "Enter your DeepSeek API Key: " llm_api_key
        echo ""
        ;;
        
    5)
        echo -e "${GREEN}Configuring for Custom Provider...${NC}"
        read -p "Enter model name: " llm_model
        read -p "Enter base URL (OpenAI-compatible): " llm_base_url
        read -sp "Enter your API Key: " llm_api_key
        echo ""
        ;;
        
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Step 2: Setting up environment variables...${NC}"

# Set required variables
railway variables set LLM_MODEL="$llm_model"
railway variables set LLM_API_KEY="$llm_api_key"

# Set base URL if provided
if [ -n "$llm_base_url" ]; then
    railway variables set LLM_BASE_URL="$llm_base_url"
fi

# Set additional recommended variables
railway variables set SANDBOX_TYPE=local
railway variables set USE_HOST_NETWORK=false
railway variables set AGENT_MEMORY_ENABLED=true
railway variables set MAX_ITERATIONS=100
railway variables set DEBUG=false

echo ""
echo -e "${GREEN}Step 3: Deploying OpenHands...${NC}"
railway up

echo ""
echo -e "${GREEN}Step 4: Getting deployment URL...${NC}"
DEPLOYMENT_URL=$(railway domain 2>/dev/null || echo "(check Railway dashboard)")

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "LLM Provider: ${YELLOW}$llm_model${NC}"
echo -e "Deployment URL: ${YELLOW}$DEPLOYMENT_URL${NC}"
echo ""
echo "Configuration Summary:"
echo "  - LLM Model: $llm_model"
echo "  - Sandbox Type: local (Railway compatible)"
echo "  - Agent Memory: enabled"
echo "  - Max Iterations: 100"
echo ""
echo -e "${YELLOW}Note: It may take 2-3 minutes for the service to fully start.${NC}"
echo -e "${YELLOW}You can check the status in your Railway dashboard.${NC}"
echo ""

# Provider-specific notes
case $provider_choice in
    1)
        echo "📚 KIMI Resources:"
        echo "   - Platform: https://platform.moonshot.cn"
        echo "   - Documentation: https://platform.moonshot.cn/docs/"
        echo "   - Check your account for rate limits and quotas"
        ;;
    2)
        echo "📚 OpenAI Resources:"
        echo "   - Platform: https://platform.openai.com"
        ;;
    3)
        echo "📚 Anthropic Resources:"
        echo "   - Platform: https://console.anthropic.com"
        ;;
esac

echo ""
echo "Happy coding with OpenHands! 🚀"
