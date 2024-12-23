require "spec_helper"
require "combined_rss_feed"

RSpec.describe CombinedRssFeed do
  it "combines a given set of feeds into an ordered list by most recent" do
    Excon.stub(
      {host: "podcast.thoughtbot.com"},
      {status: 200, body: giant_robots_feed}
    )
    Excon.stub(
      {host: "bikeshed.thoughtbot.com"},
      {status: 200, body: bike_shed_feed}
    )

    combined_items = described_class.new(
      feed_urls: [
        "https://podcast.thoughtbot.com/rss",
        "https://bikeshed.thoughtbot.com/rss"
      ]
    )
    recent = combined_items.take(3)

    expect(recent).to include(
      have_attributes(
        title: "451: Making Time for and Managing Focus",
        url: "https://bikeshed.thoughtbot.com/451",
        created_at: match_date(Date.new(2024, 12, 17))
      ),
      have_attributes(
        title: "450: Javascript-Driven Development?",
        url: "https://bikeshed.thoughtbot.com/450",
        created_at: match_date(Date.new(2024, 12, 10))
      ),
      have_attributes(
        title: "553: The One with Sami and Chad",
        url: "https://podcast.thoughtbot.com/553",
        created_at: match_date(Date.new(2024, 12, 5))
      )
    )
  end

  def giant_robots_feed
    File.read("spec/fixtures/giant_robots_feed.xml")
  end

  def bike_shed_feed
    File.read("spec/fixtures/bike_shed_feed.xml")
  end
end
