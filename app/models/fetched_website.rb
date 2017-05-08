class FetchedWebsite < ApplicationRecord
  before_validation :normalize_url
  after_commit :pre_fetch_url

  validates :url, presence: true

  def redirects?
    !!redirects_to
  end

  private

  def pre_fetch_url
    # this wait might be too much - we already have network latency, so the
    # database will almost surely be in the right state by the time we'd care
    #
    # right?
    PreFetchWebsiteJob.set(wait: 0.2.seconds).perform_later url
  end

  def normalize_url
    # this is not my favorite, but i'm not sure what else to do
    add_protocol unless protocol?
  end

  def protocol?
    url.start_with? 'http://', 'https://'
  end

  def add_protocol
    url = "http://#{url}"
  end
end
