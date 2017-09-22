class Api::OrganizationsController < ApiController
  include Roar::Rails::ControllerAdditions
  respond_to :hal

  DEFAULT_SEARCH_SIZE = 20

  before_action :ensure_term, only: :index

  def index
    organizations = Organization.estella_search(estella_options)
    respond_with organizations, represent_with: OrganizationsRepresenter
  end

  def show
    organization = Organization.find_by(id: params[:id])
    respond_with organization, represent_with: OrganizationRepresenter
  end

  private

  def estella_options
    size = params.fetch(:size, DEFAULT_SEARCH_SIZE)
    params.permit(:term).merge(size: size)
  end

  def ensure_term
    render plain: 'Missing Term', status: :bad_request unless estella_options.include?(:term)
  end
end
