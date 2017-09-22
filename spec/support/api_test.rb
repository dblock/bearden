module Api
  module Test
    extend ActiveSupport::Concern
    include Rack::Test::Methods

    included do
      let(:jwt_token) do
        JWT.encode(
          { aud: Rails.application.secrets.artsy_application_id },
          Rails.application.secrets.artsy_internal_secret
        )
      end

      let(:client) do
        Hyperclient.new('http://example.org/api') do |client|
          client.headers = {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json,application/hal+json',
            'Authorization' => "Bearer #{jwt_token}"
          }
          client.connection(default: false) do |conn|
            conn.request :json
            conn.response :json
            conn.use Faraday::Response::RaiseError
            conn.use FaradayMiddleware::FollowRedirects
            conn.use Faraday::Adapter::Rack, app
          end
        end
      end
    end
  end
end
