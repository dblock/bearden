class RawInputTransformJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    import = Import.find_by id: import_id
    return unless import
    # interested in ensuring these have been prefetched
    raw_input = import.raw_inputs.order(:id).where(state: nil).first
    import.finalize && return unless raw_input

    RawInputChanges.apply raw_input
    import_result = ImportResult.new(import)
    ActionCable.server.broadcast "import_#{import_id}", import_result
    self.class.perform_later(import_id)
  end
end
