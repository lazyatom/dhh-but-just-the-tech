require_relative 'lib/feed_parser'
require_relative 'lib/tech_classifier'
require_relative 'lib/feed_generator'

class DhhTechFilter
  FEED_URL = 'https://world.hey.com/dhh/feed.atom'

  def initialize(ai_provider = nil)
    @parser = FeedParser.new(FEED_URL)
    @classifier = TechClassifier.new(ai_provider)
  end

  def run
    puts "Fetching and parsing DHH's feed..."
    feed = @parser.fetch_and_parse
    entries = @parser.extract_entries(feed)
    
    puts "Found #{entries.length} entries, filtering for tech content..."
    
    tech_entries = []
    api_calls = 0
    cached_results = 0
    
    entries.each_with_index do |entry, index|
      print "Processing entry #{index + 1}/#{entries.length}: \"#{entry[:title]}\""
      
      was_cached = @classifier.cache_stats[:total_entries] > 0 && 
                   @classifier.instance_variable_get(:@cache).has?(entry[:id])
      
      if @classifier.is_tech_related?(entry[:id], entry[:title], entry[:content])
        tech_entries << entry
        puts was_cached ? " ✓ Tech (cached)" : " ✓ Tech"
      else
        puts was_cached ? " ✗ Non-tech (cached)" : " ✗ Non-tech"
      end
      
      was_cached ? cached_results += 1 : api_calls += 1
      
      # Add delay between API calls to avoid rate limiting
      sleep(1.0) unless was_cached
    end
    
    puts "\nClassification complete:"
    puts "  API calls made: #{api_calls}"
    puts "  Cached results used: #{cached_results}"
    
    puts "\nFound #{tech_entries.length} tech-related entries"
    
    generator = FeedGenerator.new(feed, tech_entries)
    filtered_feed = generator.generate_atom_feed
    
    File.write('dhh-tech-only.xml', filtered_feed.to_s)
    puts "Filtered feed saved to dhh-tech-only.xml"
  end
end

if __FILE__ == $0
  # Check environment variable first, then command line argument
  ai_provider = ENV['AI_PROVIDER'] || ARGV[0]

  raise "No AI provider specified. Set AI_PROVIDER environment variable or pass as command line argument." unless ai_provider
  puts "Using AI provider: #{ai_provider}"

  filter = DhhTechFilter.new(ai_provider)
  filter.run
end
