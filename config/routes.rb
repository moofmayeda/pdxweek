Rails.application.routes.draw do
  post 'restaurants/:id', to: 'votes#create'

  root 'restaurants#index'
end
