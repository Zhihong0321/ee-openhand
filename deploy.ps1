# OpenHands Railway Deployment Script with KIMI Support (PowerShell)
# Run with: .\deploy.ps1

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "OpenHands Railway Deployment Script" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🤖 Optimized for KIMI (Moonshot AI)" -ForegroundColor Cyan
Write-Host ""

# Check if Railway CLI is installed
$railwayCmd = Get-Command railway -ErrorAction SilentlyContinue
if (-not $railwayCmd) {
    Write-Host "Railway CLI not found. Installing..." -ForegroundColor Yellow
    npm install -g @railway/cli
}

# Check if user is logged in
try {
    $whoami = railway whoami 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Not logged in"
    }
} catch {
    Write-Host "Please login to Railway first:" -ForegroundColor Yellow
    railway login
}

Write-Host "Step 1: Linking to Railway project..." -ForegroundColor Green
railway link

Write-Host ""
Write-Host "=========================================" -ForegroundColor Blue
Write-Host "LLM Provider Selection" -ForegroundColor Blue
Write-Host "=========================================" -ForegroundColor Blue
Write-Host ""
Write-Host "Select your LLM provider:"
Write-Host "1) KIMI (Moonshot AI) - Recommended for coding"
Write-Host "2) OpenAI"
Write-Host "3) Anthropic Claude"
Write-Host "4) DeepSeek"
Write-Host "5) Custom (OpenAI-compatible)"
Write-Host ""

$provider_choice = Read-Host "Enter your choice (1-5)"

switch ($provider_choice) {
    "1" {
        Write-Host "Configuring for KIMI (Moonshot AI)..." -ForegroundColor Green
        $llm_base_url = "https://api.moonshot.cn/v1"
        
        Write-Host ""
        Write-Host "Select KIMI Model:"
        Write-Host "1) kimi-k2-turbo-preview - Fast, 256K context (Recommended)"
        Write-Host "2) kimi-k2 - High quality, 256K context"
        Write-Host "3) kimi-k1.5 - General purpose, 128K context"
        $kimi_model_choice = Read-Host "Enter choice (1-3, default: 1)"
        
        switch ($kimi_model_choice) {
            "2" { $llm_model = "kimi-k2" }
            "3" { $llm_model = "kimi-k1.5" }
            default { $llm_model = "kimi-k2-turbo-preview" }
        }
        
        Write-Host ""
        Write-Host "Get your API key from: https://platform.moonshot.cn" -ForegroundColor Yellow
        $secureKey = Read-Host "Enter your KIMI API Key (sk-...)" -AsSecureString
        $llm_api_key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey))
    }
    
    "2" {
        Write-Host "Configuring for OpenAI..." -ForegroundColor Green
        $llm_base_url = "https://api.openai.com/v1"
        $llm_model = Read-Host "Enter model (default: gpt-4o)"
        if (-not $llm_model) { $llm_model = "gpt-4o" }
        $secureKey = Read-Host "Enter your OpenAI API Key (sk-...)" -AsSecureString
        $llm_api_key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey))
    }
    
    "3" {
        Write-Host "Configuring for Anthropic Claude..." -ForegroundColor Green
        $llm_base_url = ""
        $llm_model = Read-Host "Enter model (default: claude-3-5-sonnet-20241022)"
        if (-not $llm_model) { $llm_model = "claude-3-5-sonnet-20241022" }
        $secureKey = Read-Host "Enter your Anthropic API Key (sk-ant-...)" -AsSecureString
        $llm_api_key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey))
    }
    
    "4" {
        Write-Host "Configuring for DeepSeek..." -ForegroundColor Green
        $llm_base_url = "https://api.deepseek.com/v1"
        $llm_model = Read-Host "Enter model (default: deepseek-chat)"
        if (-not $llm_model) { $llm_model = "deepseek-chat" }
        $secureKey = Read-Host "Enter your DeepSeek API Key" -AsSecureString
        $llm_api_key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey))
    }
    
    "5" {
        Write-Host "Configuring for Custom Provider..." -ForegroundColor Green
        $llm_model = Read-Host "Enter model name"
        $llm_base_url = Read-Host "Enter base URL (OpenAI-compatible)"
        $secureKey = Read-Host "Enter your API Key" -AsSecureString
        $llm_api_key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey))
    }
    
    default {
        Write-Host "Invalid choice. Exiting." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Step 2: Setting up environment variables..." -ForegroundColor Green

# Set required variables
railway variables set LLM_MODEL="$llm_model"
railway variables set LLM_API_KEY="$llm_api_key"

# Set base URL if provided
if ($llm_base_url) {
    railway variables set LLM_BASE_URL="$llm_base_url"
}

# Set additional recommended variables
railway variables set SANDBOX_TYPE=local
railway variables set USE_HOST_NETWORK=false
railway variables set AGENT_MEMORY_ENABLED=true
railway variables set MAX_ITERATIONS=100
railway variables set DEBUG=false

Write-Host ""
Write-Host "Step 3: Deploying OpenHands..." -ForegroundColor Green
railway up

Write-Host ""
Write-Host "Step 4: Getting deployment URL..." -ForegroundColor Green
$DEPLOYMENT_URL = railway domain 2>$null
if (-not $DEPLOYMENT_URL) {
    $DEPLOYMENT_URL = "(check Railway dashboard)"
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "🎉 Deployment Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "LLM Provider: $llm_model" -ForegroundColor Yellow
Write-Host "Deployment URL: $DEPLOYMENT_URL" -ForegroundColor Yellow
Write-Host ""
Write-Host "Configuration Summary:"
Write-Host "  - LLM Model: $llm_model"
Write-Host "  - Sandbox Type: local (Railway compatible)"
Write-Host "  - Agent Memory: enabled"
Write-Host "  - Max Iterations: 100"
Write-Host ""
Write-Host "Note: It may take 2-3 minutes for the service to fully start." -ForegroundColor Yellow
Write-Host "You can check the status in your Railway dashboard." -ForegroundColor Yellow
Write-Host ""

# Provider-specific notes
switch ($provider_choice) {
    "1" {
        Write-Host "📚 KIMI Resources:"
        Write-Host "   - Platform: https://platform.moonshot.cn"
        Write-Host "   - Documentation: https://platform.moonshot.cn/docs/"
        Write-Host "   - Check your account for rate limits and quotas"
    }
    "2" {
        Write-Host "📚 OpenAI Resources:"
        Write-Host "   - Platform: https://platform.openai.com"
    }
    "3" {
        Write-Host "📚 Anthropic Resources:"
        Write-Host "   - Platform: https://console.anthropic.com"
    }
}

Write-Host ""
Write-Host "Happy coding with OpenHands! 🚀"
