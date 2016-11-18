Rails.application.routes.draw do
  post 'webhooks/slack'
  post 'webhooks/test'
  get '/auth/:provider/callback', to: 'webhooks#authorize', as: 'authorize'
  resources :restaurants, except: [:show, :destroy]

  root 'restaurants#home'
end
