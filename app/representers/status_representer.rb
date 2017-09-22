module StatusRepresenter
  include Roar::JSON::HAL
  include Roar::Hypermedia

  property :timestamp

  link :self do
    api_status_index_url
  end
end
