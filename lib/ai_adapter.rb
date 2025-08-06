require 'openai'
require 'anthropic'
require 'dotenv/load'

class AIAdapter
  def initialize(provider = ENV['AI_PROVIDER'] || 'openai')
    @provider = provider.downcase
    @client = create_client
  end

  def classify_text(prompt)
    case @provider
    when 'openai'
      classify_with_openai(prompt)
    when 'anthropic'
      classify_with_anthropic(prompt)
    else
      raise "Unsupported AI provider: #{@provider}"
    end
  end

  private

  def create_client
    case @provider
    when 'openai'
      OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    when 'anthropic'
      Anthropic::Client.new(access_token: ENV['ANTHROPIC_API_KEY'])
    end
  end

  def classify_with_openai(prompt)
    retries = 3
    delay = 1
    
    begin
      response = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: prompt }],
          max_tokens: 10,
          temperature: 0.1
        }
      )
      
      response.dig("choices", 0, "message", "content").strip.downcase
    rescue => e
      if e.message.include?("429") && retries > 0
        puts " (rate limited, waiting #{delay}s...)"
        sleep(delay)
        retries -= 1
        delay *= 2
        retry
      else
        raise e
      end
    end
  end

  def classify_with_anthropic(prompt)
    response = @client.messages(
      parameters: {
        model: "claude-3-haiku-20240307",
        max_tokens: 10,
        messages: [{ role: "user", content: prompt }]
      }
    )
    
    response.dig("content", 0, "text").strip.downcase
  end
end
