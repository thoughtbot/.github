require "json"
require "excon"
require "feedjira"

require "feed_item"

class RssFeed
  include Enumerable

  def initialize(url:)
    @url = url
  end

  def each
    feed.entries.each do |entry|
      yield FeedItem.new(
        id: entry.id,
        title: entry.title,
        url: entry.url,
        created_at: entry.published,
        updated_at: entry.updated
      )
    end
  end

  private

  attr_reader :url

  def feed
    @feed ||=
      begin
        client = Excon.new(url)
        response = client.get
        Feedjira.parse(response.body)
      end
  end
end
