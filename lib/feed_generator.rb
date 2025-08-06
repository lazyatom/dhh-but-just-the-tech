require 'rss'
require 'time'

class FeedGenerator
  def initialize(original_feed, filtered_entries)
    @original_feed = original_feed
    @filtered_entries = filtered_entries
  end

  def generate_atom_feed
    RSS::Maker.make("atom") do |maker|
      maker.channel.author = @original_feed.author&.name&.content || "DHH"
      maker.channel.updated = Time.now.iso8601
      maker.channel.about = @original_feed.id.content
      maker.channel.title = "DHH but just the tech"
      maker.channel.description = "Articles filtered from #{@original_feed.title.content} without the uninterrogated privilege."
      maker.channel.link = @original_feed.link.href

      @filtered_entries.each do |entry_data|
        maker.items.new_item do |item|
          item.link = entry_data[:link]
          item.title = entry_data[:title]
          item.updated = entry_data[:updated]
          item.published = entry_data[:published]
          item.id = entry_data[:id]
          item.description = entry_data[:content]
          item.content_encoded = entry_data[:content]
          item.author = entry_data[:author]
        end
      end
    end
  end
end
