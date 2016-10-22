Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root 'launchpad#show'

  resources :attacks,   only: [:create]
  resources :games,     only: [:show]
end
