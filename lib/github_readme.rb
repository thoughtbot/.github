require "excon"

require "feed_item"
require "rss_feed"
require "combined_rss_feed"
require "readme"

Excon.defaults[:middlewares].push(Excon::Middleware::RedirectFollower)
