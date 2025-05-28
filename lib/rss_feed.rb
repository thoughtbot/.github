require "json"
require "excon"
require "feedjira"

require "feed_item"

class Feedjira::Parser::AtomEntry
  element "thoughtbot:auto_social_share", as: :auto_social_share
end

class RssFeed
  include Enumerable

  def initialize(url:)
    @url = url
  end

  def each
    feed.entries.reject { it.auto_social_share == "false" }.each do |entry|
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
