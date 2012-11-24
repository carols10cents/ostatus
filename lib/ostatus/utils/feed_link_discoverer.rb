require 'nokogiri'

module OStatus
  module Utils
    class FeedLinkDiscoverer
      def initialize(html_string)
        @html_string = html_string
      end

      # Store in reverse order so that the -1 from .index "not found"
      # will sort properly
      MIME_ORDER = ['application/atom+xml', 'application/rss+xml',
                    'application/xml'].reverse

      def feed_link_url
        doc = Nokogiri::HTML::Document.parse(@html_string)

        links = doc.xpath(
          "//*[contains(concat(' ',normalize-space(@rel),' '), 'alternate') or contains(concat(' ',normalize-space(@rel),' '), 'activities')]"
        ).map {|el|
          {:type => el.attributes['type'].to_s,
           :href => el.attributes['href'].to_s}
        }.sort {|a, b|
          (MIME_ORDER.index(b[:type]) || -1) <=>
          (MIME_ORDER.index(a[:type]) || -1)
        }

        links.first[:href]
      end
    end
  end
end