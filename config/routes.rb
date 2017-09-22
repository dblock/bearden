Rails.application.routes.draw do
  root to: redirect('/imports')

  namespace :api, defaults: { format: :hal } do
    get '/', to: 'root#index'
    resources :status, only: :index
    resources :organizations
  end

  require 'sidekiq/web'
  # see config/initializers/sidekiq.rb for security details
  mount Sidekiq::Web, at: '/sidekiq'

  mount ActionCable.server => :cable

  mount ArtsyAuth::Engine => '/'

  resources :imports, only: %i[create index new show]
  resources :sources, only: %i[create edit index new update]
  resources :syncs, only: :index
  resources :tags, only: :index
  resources :types, only: :index
end
