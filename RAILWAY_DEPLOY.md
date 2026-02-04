# Deploy OpenHands on Railway

This guide explains how to deploy OpenHands on Railway hosting platform.

## Prerequisites

- A Railway account (sign up at [railway.app](https://railway.app))
- Git installed on your local machine
- **For KIMI**: A Moonshot AI API key from [platform.moonshot.cn](https://platform.moonshot.cn)

## Quick Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/OPENHANDS_PLACEHOLDER)

## Manual Deployment Steps

### 1. Fork the OpenHands Repository

First, fork the official OpenHands repository to your GitHub account:

```bash
# Go to https://github.com/All-Hands-AI/OpenHands and click "Fork"
```

### 2. Add Railway Configuration Files

Add the following files to your forked repository:

#### `railway.toml`

```toml
[build]
builder = "DOCKERFILE"
dockerfilePath = "Dockerfile.railway"

[deploy]
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 10
healthcheckPath = "/health"
healthcheckTimeout = 300
```

#### `Dockerfile.railway`

Use the provided `Dockerfile.railway` in this directory.

### 3. Create a New Railway Project

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose your forked OpenHands repository

### 4. Configure Environment Variables

In your Railway project dashboard, go to the "Variables" tab and add:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `LLM_MODEL` | The LLM model to use | `kimi-k2-turbo-preview` |
| `LLM_API_KEY` | Your LLM API key | `sk-...` |
| `LLM_BASE_URL` | Base URL for LLM API | `https://api.moonshot.cn/v1` |
| `AGENT_MEMORY_ENABLED` | Enable agent memory | `true` |
| `MAX_ITERATIONS` | Maximum agent iterations | `100` |
| `DEBUG` | Enable debug mode | `false` |

## 🤖 KIMI (Moonshot AI) Configuration

### Getting Your KIMI API Key

1. Visit [platform.moonshot.cn](https://platform.moonshot.cn)
2. Sign up/login with your account
3. Go to "API Keys" section
4. Create a new API key
5. Copy the key (starts with `sk-`)

### Available KIMI Models

| Model | Context Length | Best For |
|-------|---------------|----------|
| `kimi-k2-turbo-preview` | 256K | Fast, cost-effective coding |
| `kimi-k2` | 256K | High-quality code generation |
| `kimi-k1.5` | 128K | General purpose tasks |

### KIMI Environment Variables

```bash
LLM_MODEL=kimi-k2-turbo-preview
LLM_API_KEY=sk-your-moonshot-api-key
LLM_BASE_URL=https://api.moonshot.cn/v1
AGENT_MEMORY_ENABLED=true
MAX_ITERATIONS=100
```

**Note**: OpenHands is compatible with KIMI's OpenAI-compatible API format, making integration seamless.

## 🌐 Other LLM Provider Configurations

### OpenAI
```
LLM_MODEL=gpt-4o
LLM_API_KEY=sk-your-openai-key
LLM_BASE_URL=https://api.openai.com/v1
```

### Anthropic
```
LLM_MODEL=claude-3-5-sonnet-20241022
LLM_API_KEY=sk-ant-your-anthropic-key
LLM_BASE_URL=https://api.anthropic.com
```

### Local/Ollama
```
LLM_MODEL=ollama/llama3.1
LLM_BASE_URL=http://your-ollama-server:11434
```

### Azure OpenAI
```
LLM_MODEL=azure/gpt-4o
LLM_API_KEY=your-azure-key
LLM_BASE_URL=https://your-resource.openai.azure.com/openai/deployments/your-deployment
```

### DeepSeek
```
LLM_MODEL=deepseek-chat
LLM_API_KEY=sk-your-deepseek-key
LLM_BASE_URL=https://api.deepseek.com/v1
```

## 💾 Add Persistent Storage

OpenHands needs persistent storage for workspaces:

1. In Railway dashboard, go to your service
2. Click "Add Volume"
3. Mount path: `/opt/workspace_base`
4. Size: 10GB (adjust as needed)

Add another volume for state:
- Mount path: `/.openhands`
- Size: 5GB

## 🚀 Deploy

Railway will automatically deploy when you push changes. To deploy manually:

1. Go to your service in Railway dashboard
2. Click "Deploy" button

## 🔗 Access Your Deployment

Once deployed, Railway will provide a public URL. You can find it in:
- Service dashboard → Settings → Public Domain
- Or under the "Deployments" tab

## Important Notes

### Limitations on Railway

1. **Docker Sandbox**: The full Docker-in-Docker sandbox feature is not available on Railway due to platform restrictions. The `SANDBOX_TYPE=local` setting uses a local execution environment instead.

2. **WebSocket Support**: OpenHands uses WebSockets for real-time communication. Ensure your Railway domain supports WebSocket connections.

3. **File Persistence**: Without volumes, your workspace files will be lost on redeployment. Make sure to configure volumes as described above.

### Security Considerations

1. **API Keys**: Never commit API keys to your repository. Always use Railway's environment variables.

2. **Authentication**: OpenHands doesn't have built-in authentication. Consider adding a reverse proxy with auth (like Authelia) or restrict access via Railway's networking settings.

3. **Workspace Isolation**: Each user shares the same workspace on Railway. For multi-user setups, consider deploying separate instances.

## Troubleshooting

### Health Check Failures

If the health check fails:
1. Check logs in Railway dashboard
2. Verify environment variables are set correctly
3. Ensure the PORT variable matches (default: 3000)

### Build Failures

If the build fails:
1. Verify Dockerfile.railway is present
2. Check Railway build logs for specific errors
3. Ensure you're using the correct base image tag

### Connection Issues

If you can't connect:
1. Verify the service status is "Healthy"
2. Check if the PORT environment variable is set correctly
3. Try accessing via the Railway-provided domain

### KIMI API Errors

If you get errors with KIMI:
1. Verify your API key is correct and active
2. Check if you've set `LLM_BASE_URL=https://api.moonshot.cn/v1`
3. Ensure the model name is correct (use `kimi-k2-turbo-preview` or `kimi-k2`)
4. Check your Moonshot AI account has sufficient credits

### Out of Memory

If you encounter memory issues:
1. Upgrade your Railway plan for more RAM
2. Set `MAX_ITERATIONS` to a lower value
3. Use smaller LLM models (e.g., `kimi-k2-turbo-preview` instead of larger variants)

## Updating OpenHands

To update to a newer version:

1. Update the base image tag in `Dockerfile.railway`:
   ```dockerfile
   FROM docker.all-hands.dev/all-hands-ai/openhands:NEW_VERSION
   ```

2. Commit and push changes:
   ```bash
   git add .
   git commit -m "Update OpenHands to vX.X"
   git push
   ```

3. Railway will automatically redeploy

## Alternative: Using Pre-built Image

Instead of building from Dockerfile, you can use Railway's image deployment:

1. Create a new empty service
2. Go to Settings → Source
3. Select "Deploy image"
4. Use: `docker.all-hands.dev/all-hands-ai/openhands:0.30`
5. Set the entrypoint to use the custom entrypoint script

## Support

- [OpenHands Documentation](https://docs.all-hands.dev/)
- [OpenHands GitHub Issues](https://github.com/All-Hands-AI/OpenHands/issues)
- [KIMI/Moonshot AI Documentation](https://platform.moonshot.cn/docs/)
- [Railway Documentation](https://docs.railway.app/)

## License

OpenHands is licensed under MIT. See the official repository for details.
