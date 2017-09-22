Mime::Type.register 'application/hal+json', :hal

ActionController::Renderers.add :hal do |obj, _options|
  self.content_type ||= Mime[:hal]
  obj
end
