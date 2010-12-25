# encoding: utf-8

require 'nokogiri'
module Stars
  class Favstar
    include HTTParty
    base_uri 'favstar.fm'
    proxy_url = URI.parse(ENV['http_proxy']) if ENV['http_proxy']
    http_proxy proxy_url.host,proxy_url.port if proxy_url

    def recent(username)
      self.class.get("/users/#{username}/rss",
                      :format => :xml)['rss']['channel']['item']
    end
    
    def show(url)
      # hardcode 17 to strip favstar domain for now
      html = self.class.get(url[17..200], :format => :html)

      output = ''

      Nokogiri::HTML(html).css('div[id^="faved_by_others"] img').collect do |img|
        output << "    ★   #{img.attributes['alt'].value}\n"
      end

      Nokogiri::HTML(html).css('div[id^="rt_by_others"] img').collect do |img|
        output << "    RT  #{img.attributes['alt'].value}\n"
      end

      output
    end
  end
end
