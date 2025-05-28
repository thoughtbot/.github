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

    it "ignores entries we don't automatically share to social media" do
      Excon.stub({}, {status: 200, body: <<~XML.chomp})
        <?xml version="1.0" encoding="UTF-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title>TEST_FEED_TITLE</title>
          <subtitle>TEST_SUBTITLE</subtitle>
          <id>https://example.com/</id>
          <link href="https://example.com/blog"/>
          <link href="https://example.com/blog/feed.xml" rel="self"/>
          <updated>2024-12-20T00:00:00+00:00</updated>
          <author>
            <name>TEST_NAME</name>
          </author>
          <entry>
            <title>TEST_ENTRY_1</title>
            <link rel="alternate" href="https://example.com/test-entry-1"/>
            <author>
              <name>TEST_AUTHOR</name>
            </author>
            <id>https://example.com/test-entry-1</id>
            <published>2025-05-22T00:00:00+00:00</published>
            <updated>2025-05-22T12:40:11Z</updated>
            <content type="html">
              <![CDATA[TEST_CONTENT]]>
            </content>
            <summary>TEST_SUMMARY</summary>
            <thoughtbot:auto_social_share>false</thoughtbot:auto_social_share>
          </entry>
          <entry>
            <title>TEST_ENTRY_2</title>
            <link rel="alternate" href="https://example.com/test-entry-2"/>
            <author>
              <name>TEST_AUTHOR</name>
            </author>
            <id>https://example.com/test-entry-2</id>
            <published>2025-05-29T00:00:00+00:00</published>
            <updated>2025-05-29T12:40:11Z</updated>
            <content type="html">
              <![CDATA[TEST_CONTENT]]>
            </content>
            <summary>TEST_SUMMARY</summary>
            <thoughtbot:auto_social_share>true</thoughtbot:auto_social_share>
          </entry>
        </feed>
      XML
      rss_feed = RssFeed.new url: "https://example.com/blog/feed.xml"

      entries_titles = rss_feed.map(&:title)

      expect(entries_titles).to contain_exactly "TEST_ENTRY_2"
    end

    def atom_feed
      File.read("spec/fixtures/rss_feed.xml")
    end
  end
end
