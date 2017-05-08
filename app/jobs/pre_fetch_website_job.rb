class PreFetchWebsiteJob < ActiveJob::Base
  def perform(url)
    @last_fetched = nil
    response = connection.get(url)
    parse_env(response.env)
  rescue Faraday::Error
    # not sure what to do here...
  end

  private

  def connection
    redirect_options = { callback: method(:callback) }

    @connection ||= Faraday.new do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects, redirect_options
      faraday.headers['Accept-Encoding'] = 'none'
      faraday.adapter Faraday.default_adapter
    end
  end

  def callback(old, _)
    parse_env(old)
  end

  def parse_env(faraday_env)
    url = faraday_env[:url].to_s
    status = faraday_env[:status]

    @last_fetched.update_attributes(redirects_to: url) if @last_fetched

    fetched = FetchedWebsite.find_by url: url

    if fetched
      @last_fetched = fetched
      updated = { status: status }
      fetched.update_attributes updated
    else
      attrs = { status: status, url: url }
      @last_fetched = FetchedWebsite.create attrs
    end
  end
end

# .com => .co.uk => .jp
#
# FetchedWebsite id: 1, url: '.com', status: 302, redirects_to: '.co.uk'
# FetchedWebsite id: 2, url: '.co.uk', status: 302, redirects_to: '.jp'
# FetchedWebsite id: 3, url: '.jp', status: 200, redirects_to: nil
