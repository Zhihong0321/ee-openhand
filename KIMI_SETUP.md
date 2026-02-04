# KIMI (Moonshot AI) Setup Guide for OpenHands

This guide provides detailed instructions for configuring OpenHands with KIMI AI on Railway.

## What is KIMI?

KIMI is a series of large language models developed by Moonshot AI, optimized for coding tasks and supporting both Chinese and English languages.

### Key Features
- 🚀 **Coding Optimized**: K2 series specifically fine-tuned for code generation
- 💰 **Cost Effective**: Competitive pricing compared to other providers
- 🔌 **OpenAI Compatible**: Uses standard OpenAI API format
- 🇨🇳 **Bilingual**: Excellent Chinese and English support
- 📚 **Long Context**: Up to 256K context window

## Getting Started

### Step 1: Create a Moonshot AI Account

1. Visit [platform.moonshot.cn](https://platform.moonshot.cn)
2. Sign up with email or phone number
3. Complete account verification

### Step 2: Get Your API Key

1. Login to the [KIMI Platform](https://platform.moonshot.cn)
2. Navigate to "API Keys" (API密钥管理)
3. Click "Create API Key" (创建API Key)
4. Copy the key (format: `sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`)

⚠️ **Important**: Save this key immediately - you won't be able to see it again!

### Step 3: Check Your Quota

1. Go to "Usage" (用量管理) in the dashboard
2. Check your available credits
3. Top up if needed (supports Alipay, WeChat Pay, etc.)

## KIMI Models Reference

| Model | Context | Speed | Best For | Input Price* | Output Price* |
|-------|---------|-------|----------|--------------|---------------|
| `kimi-k2-turbo-preview` | 256K | ⚡ Fast | Quick coding, prototyping | ¥0.7/1M tokens | ¥2.8/1M tokens |
| `kimi-k2` | 256K | 🐢 Balanced | Complex code, analysis | ¥2.0/1M tokens | ¥8.0/1M tokens |
| `kimi-k1.5` | 128K | 🐢 Balanced | General tasks | ¥1.2/1M tokens | ¥4.8/1M tokens |

*Prices as of 2025, subject to change. Check [platform.moonshot.cn](https://platform.moonshot.cn) for current pricing.

## Configuration

### Environment Variables

```bash
# Required
LLM_MODEL=kimi-k2-turbo-preview
LLM_API_KEY=sk-your-moonshot-api-key
LLM_BASE_URL=https://api.moonshot.cn/v1

# Optional but Recommended
AGENT_MEMORY_ENABLED=true
MAX_ITERATIONS=100
```

### Railway Deployment

#### Option 1: Using deploy.sh Script

```bash
chmod +x deploy.sh
./deploy.sh

# Select option 1 for KIMI when prompted
```

#### Option 2: Railway CLI Direct

```bash
railway login
railway link

railway variables set LLM_MODEL=kimi-k2-turbo-preview
railway variables set LLM_API_KEY=sk-your-api-key
railway variables set LLM_BASE_URL=https://api.moonshot.cn/v1
railway variables set AGENT_MEMORY_ENABLED=true

railway up
```

#### Option 3: Railway Dashboard

1. Go to your Railway project
2. Click on your service
3. Go to "Variables" tab
4. Add each variable individually

### Local Testing

```bash
# Using Docker Compose
cp config/kimi.env .env
# Edit .env with your API key
docker-compose -f docker-compose.railway.yml up -d
```

Or inline:

```bash
LLM_MODEL=kimi-k2-turbo-preview \
LLM_API_KEY=sk-your-key \
LLM_BASE_URL=https://api.moonshot.cn/v1 \
docker-compose -f docker-compose.railway.yml up -d
```

## Testing Your Setup

Once deployed, test KIMI integration:

1. Open your OpenHands URL (from Railway dashboard)
2. Start a new conversation
3. Try a coding task:
   ```
   Write a Python function to calculate fibonacci numbers
   ```
4. KIMI should respond with code and explanations

## Troubleshooting

### API Key Issues

**Error**: "Invalid API key" or "Authentication failed"

**Solutions**:
1. Verify your API key is complete (starts with `sk-`)
2. Check if the key is still valid in Moonshot dashboard
3. Ensure no extra spaces in the environment variable

### Rate Limit Errors

**Error**: "Rate limit exceeded" or "Too many requests"

**Solutions**:
1. Check your usage quota in Moonshot dashboard
2. Reduce `MAX_ITERATIONS` value
3. Upgrade your Moonshot plan
4. Add delay between requests

### Model Not Found

**Error**: "Model not found" or "Invalid model"

**Solutions**:
1. Use exact model names:
   - `kimi-k2-turbo-preview` (correct)
   - `kimi-k2-preview` (incorrect)
2. Check for typos in model name

### Connection Issues

**Error**: "Connection timeout" or "Network error"

**Solutions**:
1. Verify `LLM_BASE_URL=https://api.moonshot.cn/v1`
2. Check if you're in a region where Moonshot API is accessible
3. Try using a VPN if accessing from outside China

### Chinese Character Issues

If you see garbled Chinese text:
1. This is usually a display issue, not API issue
2. Try refreshing the browser
3. Check browser encoding settings (should be UTF-8)

## Best Practices

### For Coding Tasks

1. **Use kimi-k2-turbo-preview** for quick iterations and prototyping
2. **Use kimi-k2** for complex algorithms and detailed code review
3. **Enable memory** (`AGENT_MEMORY_ENABLED=true`) for multi-file projects

### Cost Optimization

1. Start with `kimi-k2-turbo-preview` (cheapest)
2. Monitor usage in Moonshot dashboard
3. Set `MAX_ITERATIONS` to prevent runaway costs
4. Use caching for repeated operations

### Security

1. Never commit API keys to git
2. Use Railway environment variables
3. Rotate API keys regularly
4. Monitor API usage for anomalies

## Example Tasks

Here are some tasks that work well with KIMI:

```
"Create a React component for a todo list with TypeScript"
"Refactor this Python code to use async/await"
"Explain how this algorithm works and optimize it"
"Write unit tests for this function"
"Create a Docker setup for this Node.js project"
"Debug this error: [paste error message]"
```

## Migration from Other Providers

### From OpenAI

Simply change:
```bash
# Old
LLM_MODEL=gpt-4o
LLM_API_KEY=sk-openai-key
LLM_BASE_URL=https://api.openai.com/v1

# New
LLM_MODEL=kimi-k2-turbo-preview
LLM_API_KEY=sk-moonshot-key
LLM_BASE_URL=https://api.moonshot.cn/v1
```

### From Anthropic

```bash
# Old
LLM_MODEL=claude-3-5-sonnet-20241022
LLM_API_KEY=sk-ant-api-key
# No LLM_BASE_URL needed

# New
LLM_MODEL=kimi-k2
LLM_API_KEY=sk-moonshot-key
LLM_BASE_URL=https://api.moonshot.cn/v1
```

## Support Resources

- [Moonshot AI Documentation](https://platform.moonshot.cn/docs/)
- [KIMI API Reference](https://platform.moonshot.cn/docs/api-reference)
- [OpenHands Documentation](https://docs.all-hands.dev/)
- [Moonshot AI Discord/Community](https://platform.moonshot.cn/)

## FAQ

**Q: Is KIMI better than GPT-4 for coding?**
A: KIMI K2 is competitive with GPT-4 for many coding tasks, especially those involving Chinese context. Try both and compare for your specific use case.

**Q: Can I use KIMI outside China?**
A: Yes, but you may experience higher latency. The API is accessible globally.

**Q: How do I check my API usage?**
A: Visit [platform.moonshot.cn](https://platform.moonshot.cn) and go to the "Usage" section.

**Q: What payment methods are accepted?**
A: Moonshot accepts Alipay, WeChat Pay, and bank transfers for Chinese users.

**Q: Is there a free tier?**
A: Check the Moonshot platform for current promotions. They occasionally offer trial credits.

**Q: Can I use KIMI with other OpenAI-compatible tools?**
A: Yes! Any tool that supports custom OpenAI-compatible endpoints should work with KIMI.
