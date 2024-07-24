require 'sidekiq/web'

Rails.application.routes.draw do
  root 'home#index'
  mount Sidekiq::Web => '/sidekiq'
  get 'search', to: 'search#index'
end
