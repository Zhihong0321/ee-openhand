# GitHub Actions Secrets Setup

This guide shows you how to set up GitHub Actions secrets for automated deployment to Railway.

## Required Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions → New repository secret

### 1. RAILWAY_TOKEN

Get your Railway API token:

```bash
# Login to Railway
railway login

# Generate a token
railway token
```

Copy the token and add it as `RAILWAY_TOKEN` in GitHub secrets.

### 2. RAILWAY_PROJECT_ID

Get your project ID:

```bash
# In your project directory
railway status
```

Or from Railway dashboard URL: `https://railway.app/project/PROJECT_ID`

Add it as `RAILWAY_PROJECT_ID` in GitHub secrets.

### 3. RAILWAY_SERVICE_ID

Get your service ID:

```bash
# In your project directory
railway status
```

Add it as `RAILWAY_SERVICE_ID` in GitHub secrets.

### 4. LLM Provider API Keys

Add at least one of these based on your chosen provider:

#### For KIMI (Recommended)
- Secret name: `KIMI_API_KEY`
- Value: Your API key from https://platform.moonshot.cn (starts with `sk-`)

#### For OpenAI
- Secret name: `OPENAI_API_KEY`
- Value: Your OpenAI API key (starts with `sk-`)

#### For Anthropic
- Secret name: `ANTHROPIC_API_KEY`
- Value: Your Anthropic API key (starts with `sk-ant-`)

#### For DeepSeek
- Secret name: `DEEPSEEK_API_KEY`
- Value: Your DeepSeek API key

## Secrets Summary Table

| Secret Name | Required | Description |
|-------------|----------|-------------|
| `RAILWAY_TOKEN` | Yes | Railway API authentication token |
| `RAILWAY_PROJECT_ID` | Yes | Your Railway project ID |
| `RAILWAY_SERVICE_ID` | Yes | Your Railway service ID |
| `KIMI_API_KEY` | Optional* | KIMI/Moonshot AI API key |
| `OPENAI_API_KEY` | Optional* | OpenAI API key |
| `ANTHROPIC_API_KEY` | Optional* | Anthropic API key |
| `DEEPSEEK_API_KEY` | Optional* | DeepSeek API key |

*At least one LLM provider API key is required

## Automated Deployment

Once secrets are configured, deployments will happen automatically:

1. **On every push to main/master** - Auto-deploy with default provider (KIMI)
2. **Manual trigger** - Go to Actions → Deploy to Railway → Run workflow → Select provider

## Testing Locally

Before setting up GitHub Actions, test locally:

```bash
# Set environment variables
export RAILWAY_TOKEN=your-token
export RAILWAY_PROJECT_ID=your-project-id
export RAILWAY_SERVICE_ID=your-service-id
export KIMI_API_KEY=sk-your-kimi-key

# Run deployment
railway up
```
