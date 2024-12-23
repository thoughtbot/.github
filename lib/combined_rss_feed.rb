require "rss_feed"

class CombinedRssFeed
  include Enumerable

  def initialize(feed_urls:)
    @rss_feeds = feed_urls.map { |url| RssFeed.new(url: url) }
  end

  def each
    rss_feeds
      .map(&:entries)
      .flatten
      .compact
      .sort_by(&:created_at)
      .reverse!
      .each { |entry| yield entry }
  end

  private

  attr_reader :rss_feeds
end
