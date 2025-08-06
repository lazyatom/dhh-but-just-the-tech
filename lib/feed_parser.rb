require 'rss'
require 'net/http'
require 'uri'

class FeedParser
  def initialize(feed_url)
    @feed_url = feed_url
  end

  def fetch_and_parse
    uri = URI(@feed_url)
    response = Net::HTTP.get_response(uri)
    
    raise "Failed to fetch feed: #{response.code}" unless response.code == '200'
    
    RSS::Parser.parse(response.body)
  end

  def extract_entries(feed)
    feed.entries.map do |entry|
      {
        id: entry.id.content,
        title: entry.title.content,
        content: entry.content.content,
        published: entry.published.content,
        updated: entry.updated.content,
        link: entry.link.href,
        author: entry.author.name.content
      }
    end
  end
end