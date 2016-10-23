Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root 'launchpad#show'

  resources :attacks,   only: [:create]
  resources :bombings,  only: [:create]
  resources :defenses,  only: [:create]
  resources :games,     only: [:show, :create]
  resources :players,   only: [:update]
end
