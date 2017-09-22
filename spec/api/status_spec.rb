require 'rails_helper'

describe Api::StatusController do
  include Api::Test

  it 'returns a timestamp' do
    Timecop.freeze do
      expect(client.status.timestamp).to eq Time.now.utc.to_i
    end
  end
end
