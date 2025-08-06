require 'json'
require 'digest'

class ClassificationCache
  def initialize(cache_file = 'classification_cache.json')
    @cache_file = cache_file
    @cache = load_cache
  end

  def get(entry_id)
    @cache[entry_id]
  end

  def set(entry_id, is_tech)
    @cache[entry_id] = is_tech
    save_cache
  end

  def has?(entry_id)
    @cache.key?(entry_id)
  end

  def cache_stats
    { total_entries: @cache.size }
  end

  private

  def load_cache
    return {} unless File.exist?(@cache_file)
    
    JSON.parse(File.read(@cache_file))
  rescue JSON::ParserError
    {}
  end

  def save_cache
    File.write(@cache_file, JSON.pretty_generate(@cache))
  end
end