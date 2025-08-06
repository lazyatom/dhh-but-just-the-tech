require_relative 'ai_adapter'
require_relative 'classification_cache'

class TechClassifier
  def initialize(ai_provider = nil)
    @ai_adapter = AIAdapter.new(ai_provider)
    @cache = ClassificationCache.new
  end

  def is_tech_related?(entry_id, title, content)
    if @cache.has?(entry_id)
      return @cache.get(entry_id)
    end

    prompt = build_classification_prompt(title, content)
    result = @ai_adapter.classify_text(prompt)
    is_tech = result == "yes"
    
    @cache.set(entry_id, is_tech)
    is_tech
  end

  def cache_stats
    @cache.cache_stats
  end

  private

  def build_classification_prompt(title, content)
    <<~PROMPT
      Determine if this article is primarily about technology, software, programming, hardware, or technical topics.

      Title: #{title}
      
      Content: #{content[0..1000]}...

      Answer only "YES" if this is primarily a technical/technology article, or commentary about technology and tech companies. Answer "NO" if it's right- or conservative-leaning social commentary with no mention of technology.

      Answer:
    PROMPT
  end
end
