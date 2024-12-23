require "spec_helper"
require "github_readme"

RSpec.describe FeedItem do
  describe "#to_readme_line" do
    it "is a markdown link to the feed item" do
      feed_item = described_class.new(
        id: nil,
        title: "Blog Post",
        url: "http://example.com",
        created_at: nil,
        updated_at: nil,
      )

      expect(feed_item.to_readme_line).to eq(
        "[Blog Post](http://example.com)\n",
      )
    end
  end
end
