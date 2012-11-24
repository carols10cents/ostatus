require_relative '../../lib/ostatus/utils/feed_link_discoverer'

describe OStatus::Utils::FeedLinkDiscoverer do
  it "can handle HTML5 tags in the page" do
    f = OStatus::Utils::FeedLinkDiscoverer.new(
      <<-HERE
        <html dir="ltr" lang="en-US">
          <head>
            <link rel="alternate"
                  type="application/rss+xml"
                  title="ssweeny.net &raquo; Feed"
                  href="http://ssweeny.net/feed/" />
          </head>
          <footer>This is an HTML5 tag.</footer
        </html>
      HERE
    )
    f.feed_link_url.should eql "http://ssweeny.net/feed/"
  end

  it "will use links with rel=activities" do
    # This is to support the Wordpress ActivityStreams plugin:
    # https://wordpress.org/extend/plugins/activitystream-extension/
    f = OStatus::Utils::FeedLinkDiscoverer.new(
      <<-HERE
        <html dir="ltr" lang="en-US">
          <head>
            <link rel="activities"
                  type="application/atom+xml"
                  href="http://ssweeny.net/feed/atom/" />
          </head>
        </html>
      HERE
    )
    f.feed_link_url.should eql "http://ssweeny.net/feed/atom/"
  end

  it "prefers application/atom+xml over application/rss+xml" do
    f = OStatus::Utils::FeedLinkDiscoverer.new(
      <<-HERE
        <html dir="ltr" lang="en-US">
          <head>
            <link rel="alternate"
                  type="application/rss+xml"
                  href="http://ssweeny.net/feed/foo/" />
            <link rel="alternate"
                  type="application/rss+xml"
                  href="http://ssweeny.net/feed/bar/" />
            <link rel="alternate"
                  type="application/rss+xml"
                  href="http://ssweeny.net/feed/" />
            <link rel="alternate"
                  type="application/atom+xml"
                  href="http://ssweeny.net/feed/atom/" />
            <link rel="alternate"
                  type="application/nothing-we-want"
                  href="http://ssweeny.net/nothing/" />
          </head>
        </html>
      HERE
    )
    f.feed_link_url.should eql "http://ssweeny.net/feed/atom/"
  end
end