module OrganizationRepresenter
  include Roar::JSON::HAL
  include Roar::Hypermedia

  property :names
  property :tag_names
  property :website_urls
  property :cities
  property :countries
  property :in_business

  link :self do
    api_organization_url(represented)
  end
end
