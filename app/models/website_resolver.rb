class WebsiteResolver
  attr_reader :results

  def self.resolve(url)
    resolver = new(url)
    resolver.resolve
    resolver
  end

  def initialize(url)
    @url = url
    @results = []
  end

  def resolve
    resolve_url if @url
  end

  def resolved_url
    @results.last&.fetch :content
  end

  private

  def resolve_url
    # we have to do this because our url is straight from the RawInput
    add_protocol unless protocol?
    find_fetched(@url)
  end

  def protocol?
    @url.start_with? 'http://', 'https://'
  end

  def add_protocol
    @url = "http://#{@url}"
  end

  def find_fetched(url)
    # what should happen when fetched is nil!
    fetched = FetchedWebsite.find_by url: url
    add_result(fetched)
    find_fetched(fetched.redirects_to) if fetched.redirects?
  end

  def add_result(fetched_website)
    result = { status: fetched_website.status, content: fetched_website.url }
    @results << result
  end
end
