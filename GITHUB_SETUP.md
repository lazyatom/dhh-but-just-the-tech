# GitHub Setup Guide

This guide walks through setting up the automated feed generation and hosting on GitHub.

## Required GitHub Secrets

You need to configure at least one AI provider's API key in your repository secrets:

### Option 1: Using OpenAI

1. Get an API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Go to your GitHub repository → Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `OPENAI_API_KEY`
5. Value: Your OpenAI API key
6. Click "Add secret"

### Option 2: Using Anthropic

1. Get an API key from [Anthropic Console](https://console.anthropic.com/)
2. Go to your GitHub repository → Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `ANTHROPIC_API_KEY`
5. Value: Your Anthropic API key
6. Click "Add secret"

### Optional: Set Default AI Provider

1. Go to Settings → Secrets and variables → Actions → Variables tab
2. Click "New repository variable"
3. Name: `AI_PROVIDER`
4. Value: Either `openai` or `anthropic`
5. Click "Add variable"

If not set, defaults to `openai`.

## Enable GitHub Pages

1. Go to your repository's **Settings** tab
2. Scroll down to **Pages** section in the sidebar
3. Under **Source**, select "Deploy from a branch"
4. Under **Branch**, select `gh-pages` (will be created after first workflow run)
5. Leave folder as `/ (root)`
6. Click **Save**

## First Run

After setting up secrets and enabling GitHub Pages:

1. Go to the **Actions** tab in your repository
2. Click on "Update DHH Tech Feed" workflow
3. Click "Run workflow" button
4. Select the branch (usually `main`)
5. Click "Run workflow"

The workflow will:
- Install Ruby dependencies
- Fetch DHH's feed
- Classify posts using AI
- Generate the filtered feed
- Deploy to GitHub Pages

## Verify Deployment

After the workflow completes:

1. Check the Actions tab for a green checkmark
2. Visit your GitHub Pages URL:
   - `https://[YOUR-USERNAME].github.io/dhh-but-just-the-tech/`
   - You should see a landing page with feed subscription links

3. The RSS feed will be available at:
   - `https://[YOUR-USERNAME].github.io/dhh-but-just-the-tech/feed.xml`
   - `https://[YOUR-USERNAME].github.io/dhh-but-just-the-tech/feed.atom`

## Monitoring

- The workflow runs automatically every 6 hours
- Check the Actions tab for workflow run history
- Classification cache is preserved between runs to minimize API usage
- Each run shows API calls made vs cached results used

## Troubleshooting

### Workflow Fails with Authentication Error
- Verify your API key is correctly set in repository secrets
- Ensure the API key has sufficient credits/quota

### GitHub Pages Not Showing
- Ensure Pages is enabled in repository settings
- Wait a few minutes after first deployment
- Check if `gh-pages` branch was created

### Feed Not Updating
- Check Actions tab for failed workflows
- Review workflow logs for specific errors
- Ensure classification_cache.json isn't corrupted

### Rate Limiting
- The workflow includes delays between API calls
- Classification cache reduces API calls over time
- Consider using a more economical AI model if hitting limits