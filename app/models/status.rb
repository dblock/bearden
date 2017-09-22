class Status
  include ActiveModel::Model

  def timestamp
    Time.now.utc.to_i
  end
end
