module RootRepresenter
  include Roar::JSON::HAL
  include Roar::Hypermedia

  link :status do
    api_status_index_url
  end

  link :organizations do
    {
      href: "#{api_organizations_url}/{?term,size}",
      templated: true
    }
  end

  link :organization do
    {
      href: "#{api_organizations_url}/{id}",
      templated: true
    }
  end
end
