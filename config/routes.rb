require 'sidekiq/web'

Rails.application.routes.draw do
  # Mount Sidekiq web UI
  mount Sidekiq::Web => '/sidekiq'

end
