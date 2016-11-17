Rails.application.routes.draw do
  post 'webhooks/slack'
  resources :restaurants, except: [:show, :destroy]

  root 'restaurants#home'
end
