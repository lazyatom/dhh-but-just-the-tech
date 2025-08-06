# DHH But Just The Tech

An automatically updated RSS/Atom feed that filters [DHH's blog](https://world.hey.com/dhh) to include only technology and programming-related posts.

## 📡 Subscribe to the Feed

Once deployed to GitHub Pages, the feed will be available at:

- **RSS/Atom Feed:** `https://[YOUR-GITHUB-USERNAME].github.io/dhh-but-just-the-tech/feed.xml`
- **Alternative:** `https://[YOUR-GITHUB-USERNAME].github.io/dhh-but-just-the-tech/feed.atom`

## 🚀 Setup Instructions

### 1. Fork or Clone this Repository

```bash
git clone https://github.com/[YOUR-USERNAME]/dhh-but-just-the-tech.git
cd dhh-but-just-the-tech
```

### 2. Configure GitHub Secrets

Go to your repository's Settings → Secrets and variables → Actions, and add:

- **`OPENAI_API_KEY`** - Your OpenAI API key (if using OpenAI)
- **`ANTHROPIC_API_KEY`** - Your Anthropic API key (if using Anthropic)

Optionally, you can also set a repository variable:
- **`AI_PROVIDER`** - Either `openai` or `anthropic` (defaults to `openai`)

### 3. Enable GitHub Pages

1. Go to Settings → Pages
2. Set Source to "Deploy from a branch"
3. Select `gh-pages` branch and `/ (root)` folder
4. Click Save

### 4. Run the Workflow

The feed will update automatically:
- Every 6 hours via scheduled cron job
- When you push changes to the main branch
- Manually via the Actions tab → "Update DHH Tech Feed" → "Run workflow"

## 🛠️ How It Works

1. **Fetches** DHH's blog feed from `https://world.hey.com/dhh/feed.atom`
2. **Classifies** each post using AI to determine if it's tech-related
3. **Caches** classification results to minimize API calls
4. **Generates** a filtered Atom feed with only technical content
5. **Deploys** the feed to GitHub Pages for public access

## 💻 Local Development

### Prerequisites

- Ruby 3.3.0
- Bundler

### Setup

```bash
# Install dependencies
bundle install

# Create .env file with your API keys
echo "OPENAI_API_KEY=your-key-here" > .env
# OR
echo "ANTHROPIC_API_KEY=your-key-here" > .env

# Run the filter
ruby main.rb

# Or specify the AI provider
ruby main.rb openai
ruby main.rb anthropic
```

The filtered feed will be saved to `dhh-tech-only.xml`.

## 📂 Project Structure

- `main.rb` - Entry point that orchestrates the feed filtering
- `lib/feed_parser.rb` - Fetches and parses the Atom feed
- `lib/tech_classifier.rb` - Uses AI to classify content as tech-related
- `lib/ai_adapter.rb` - Abstraction for OpenAI and Anthropic APIs
- `lib/classification_cache.rb` - Caches classification results
- `lib/feed_generator.rb` - Generates the filtered Atom feed
- `classification_cache.json` - Persistent cache of classification results
- `.github/workflows/update-feed.yml` - GitHub Actions workflow for automation

## 🔄 Automation

The GitHub Actions workflow:
- Runs every 6 hours automatically
- Caches classification results to avoid redundant API calls
- Deploys the updated feed to GitHub Pages
- Preserves the classification cache between runs

## 📝 License

This project filters public blog content for personal use. Please respect the original content creator's rights and terms of service.