require "spec_helper"
require "github_readme"

RSpec.describe RssFeed do
  describe "#recent" do
    it "fetches the top 5 most recent posts" do
      Excon.stub({}, { status: 200, body: atom_feed })
      rss_feed = described_class.new(
        url: "https://feeds.feedburner.com/GiantRobotsSmashingIntoOtherGiantRobots"
      )

      recent = rss_feed.take(5)

      expect(recent.count).to eq(5)
    end

    it "builds a FeedItem from a feed item" do
      Excon.stub({}, { status: 200, body: atom_feed })
      rss_feed = described_class.new(
        url: "https://feeds.feedburner.com/GiantRobotsSmashingIntoOtherGiantRobots"
      )

      recent = rss_feed.take(5)

      expect(recent.first).to have_attributes(
        title: "Optimize your shell experience",
        url: "https://thoughtbot.com/blog/optimize-your-shell-experience",
        created_at: Time.new(2024, 12, 20)
      )
    end

    def atom_feed
      File.read("spec/fixtures/rss_feed.xml")
    end
  end
end
