class Api::StatusController < ApiController
  include Roar::Rails::ControllerAdditions
  respond_to :hal

  def index
    respond_with Status.new, represent_with: StatusRepresenter
  end
end
