require "rss_feed"

class Feedjira::Parser::ITunesRSSItem
  element "thoughtbot:auto_social_share", as: :auto_social_share
end

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
