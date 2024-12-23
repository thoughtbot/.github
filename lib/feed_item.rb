class FeedItem
  attr_accessor :id, :title, :url, :updated_at, :created_at

  def initialize(id:, title:, url:, created_at:, updated_at:)
    @id = id
    @title = title
    @url = url
    @created_at = created_at
    @updated_at = updated_at
  end

  def to_readme_line
    "[#{title}](#{url})\n"
  end
end
