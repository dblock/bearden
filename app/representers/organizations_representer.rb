module OrganizationsRepresenter
  include Roar::JSON::HAL
  include Roar::Hypermedia

  collection :to_a, extend: OrganizationRepresenter, as: :organizations, embedded: true
end
