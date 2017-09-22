class Api::RootController < ApiController
  include Roar::Rails::ControllerAdditions
  respond_to :hal

  def index
    respond_with Object.new, represent_with: RootRepresenter
  end
end
