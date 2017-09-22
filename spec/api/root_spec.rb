require 'rails_helper'

describe Api::RootController do
  include Api::Test

  it 'hypermedia root' do
    expect(client._resource._links.status.to_s).to end_with '/api/status'
  end

  context 'with no token' do
    it 'returns a 401 with an error message' do
      get '/api'
      expect(last_response.status).to eq 401
      expect(last_response.body).to eq 'Access Denied'
    end
  end

  context 'with an invalid token' do
    it 'returns a 401 with an error message' do
      headers = { 'Authorization' => 'invalid' }
      get '/api', headers: headers
      expect(last_response.status).to eq 401
      expect(last_response.body).to eq 'Access Denied'
    end
  end
end
