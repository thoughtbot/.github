require "tmpdir"

require "spec_helper"
require "github_readme"

RSpec.describe Readme do
  describe "#update" do
    it "sets the content" do
      with_temp_directory do |dir|
        File.write("README.md", readme_body)
        readme = described_class.new("README.md")
        items = [
          FeedItem.new(
            id: nil,
            title: "Optimising your shell experience",
            url: "https://thoughtbot.com/blog/optimize-your-shell-experience",
            created_at: Date.new(2024, 12, 20),
            updated_at: nil
          )
        ]

        readme.update(section: "blog", items: items)

        expect(File.read("README.md")).to include(
          "[Optimising your shell experience](https://thoughtbot.com/blog/optimize-your-shell-experience)"
        )
      end
    end
  end

  def with_temp_directory
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        yield(dir)
      end
    end
  end

  def readme_body
    <<~BODY
      Some intro text

      <!-- blog starts -->
      <!-- blog ends -->
    BODY
  end
end
