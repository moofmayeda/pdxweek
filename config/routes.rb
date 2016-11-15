Rails.application.routes.draw do
  post 'webhooks/slack'
  post 'restaurants/:id', to: 'votes#create', as: 'vote'

  root 'restaurants#index'
end
