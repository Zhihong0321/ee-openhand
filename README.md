# OpenHands Railway Deployment

This repository contains configuration files and documentation for deploying [OpenHands](https://github.com/All-Hands-AI/OpenHands) on [Railway](https://railway.app) hosting platform.

## 🤖 Pre-configured for KIMI (Moonshot AI)

This deployment is optimized for **KIMI AI** (by Moonshot), a powerful coding-focused LLM with OpenAI-compatible API.

### Why KIMI?
- 🚀 **Optimized for coding**: KIMI K2 series excels at code generation and understanding
- 💰 **Cost-effective**: Competitive pricing for high-quality output
- 🔌 **OpenAI-compatible**: Drop-in replacement, no code changes needed
- 🇨🇳 **Great Chinese support**: Excellent for bilingual coding tasks

## 📁 Files Included

| File | Description |
|------|-------------|
| `railway.toml` | Railway configuration as code |
| `railway.json` | Alternative Railway configuration (JSON format) |
| `Dockerfile.railway` | Optimized Dockerfile for Railway deployment |
| `docker-compose.railway.yml` | Local testing configuration |
| `deploy.sh` | Automated deployment script |
| `RAILWAY_DEPLOY.md` | Detailed deployment documentation |
| `.github/workflows/railway-deploy.yml` | GitHub Actions CI/CD workflow |
| `config/kimi.env` | Pre-configured KIMI environment variables |

## 🚀 Quick Start with KIMI

### Step 1: Get Your KIMI API Key

1. Visit [platform.moonshot.cn](https://platform.moonshot.cn)
2. Sign up/login with your account
3. Go to "API Keys" section and create a new key
4. Copy the key (starts with `sk-`)

### Step 2: Deploy to Railway

#### Option A: One-Click Deploy (Coming Soon)
[![Deploy on Railway](https://railway.app/button.svg)]()

#### Option B: Using Deployment Script

```bash
# Clone or fork the OpenHands repository
git clone https://github.com/All-Hands-AI/OpenHands.git
cd OpenHands

# Copy the Railway files from this repo
cp -r /path/to/this/repo/* .

# Run deployment with KIMI configuration
chmod +x deploy.sh
./deploy.sh
```

#### Option C: Railway CLI

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and link project
railway login
railway link

# Set KIMI environment variables
railway variables set LLM_MODEL=kimi-k2-turbo-preview
railway variables set LLM_API_KEY=sk-your-kimi-api-key
railway variables set LLM_BASE_URL=https://api.moonshot.cn/v1
railway variables set AGENT_MEMORY_ENABLED=true
railway variables set MAX_ITERATIONS=100

# Deploy
railway up
```

## ⚙️ KIMI Configuration

### Available Models

| Model | Context | Best For | Speed |
|-------|---------|----------|-------|
| `kimi-k2-turbo-preview` | 256K | Coding, fast iteration | ⚡ Fast |
| `kimi-k2` | 256K | Complex code generation | 🐢 Balanced |
| `kimi-k1.5` | 128K | General tasks | 🐢 Balanced |

**Recommended for coding**: `kimi-k2-turbo-preview`

### Environment Variables

```bash
# Required
LLM_MODEL=kimi-k2-turbo-preview          # or kimi-k2, kimi-k1.5
LLM_API_KEY=sk-your-moonshot-api-key
LLM_BASE_URL=https://api.moonshot.cn/v1

# Optional
AGENT_MEMORY_ENABLED=true                # Enable conversation memory
MAX_ITERATIONS=100                       # Max agent action iterations
DEBUG=false                              # Enable debug logging
```

## 🔧 Local Testing with KIMI

Test the Railway configuration locally before deploying:

```bash
# Set your KIMI credentials
export LLM_MODEL=kimi-k2-turbo-preview
export LLM_API_KEY=sk-your-kimi-api-key
export LLM_BASE_URL=https://api.moonshot.cn/v1

# Run with Docker Compose
docker-compose -f docker-compose.railway.yml up -d

# Access OpenHands at http://localhost:3000
```

## 🌐 Using Other LLM Providers

While optimized for KIMI, this setup works with any OpenAI-compatible API:

### OpenAI
```bash
LLM_MODEL=gpt-4o
LLM_API_KEY=sk-openai-key
LLM_BASE_URL=https://api.openai.com/v1
```

### Anthropic Claude
```bash
LLM_MODEL=claude-3-5-sonnet-20241022
LLM_API_KEY=sk-ant-api-key
# LLM_BASE_URL not needed for Anthropic
```

### DeepSeek
```bash
LLM_MODEL=deepseek-chat
LLM_API_KEY=sk-deepseek-key
LLM_BASE_URL=https://api.deepseek.com/v1
```

### Azure OpenAI
```bash
LLM_MODEL=azure/gpt-4o
LLM_API_KEY=your-azure-key
LLM_BASE_URL=https://your-resource.openai.azure.com/openai/deployments/your-deployment
```

### Ollama (Local)
```bash
LLM_MODEL=ollama/llama3.1
LLM_BASE_URL=http://host.docker.internal:11434
```

## ⚠️ Important Notes

1. **Docker Sandbox**: Railway doesn't support Docker-in-Docker. The deployment uses `SANDBOX_TYPE=local` instead.

2. **Persistent Storage**: Configure volumes in Railway dashboard for `/opt/workspace_base` and `/.openhands` to persist data.

3. **Authentication**: OpenHands doesn't include built-in authentication. Consider adding a reverse proxy with auth for production use.

4. **WebSockets**: Ensure your Railway domain supports WebSocket connections for real-time features.

5. **KIMI Rate Limits**: Check your Moonshot AI account for rate limits and quotas.

## 🔄 Updating

To update OpenHands:

1. Update the version tag in `Dockerfile.railway`:
   ```dockerfile
   FROM docker.all-hands.dev/all-hands-ai/openhands:NEW_VERSION
   ```

2. Commit and push changes - Railway will auto-deploy

## 📚 Resources

- [OpenHands Official Repo](https://github.com/All-Hands-AI/OpenHands)
- [OpenHands Documentation](https://docs.all-hands.dev/)
- [KIMI/Moonshot AI Platform](https://platform.moonshot.cn/)
- [KIMI API Documentation](https://platform.moonshot.cn/docs/)
- [Railway Documentation](https://docs.railway.app/)

## 💡 Tips for KIMI + OpenHands

1. **For complex coding tasks**: Use `kimi-k2` model
2. **For quick iterations**: Use `kimi-k2-turbo-preview`
3. **Enable memory**: Set `AGENT_MEMORY_ENABLED=true` for multi-turn conversations
4. **Adjust iterations**: Increase `MAX_ITERATIONS` for complex tasks (default: 100)

## 📝 License

This deployment configuration follows the same license as OpenHands (MIT).
