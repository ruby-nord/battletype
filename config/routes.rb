Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root 'launchpad#show'

  resources :attacks,   only: [:create]
  resources :bombings,  only: [:create]
  resources :defenses,  only: [:create]

  resources :games,     only: [:show, :create] do
    resource :opponent, only: [:create], controller: 'opponent'
  end

  resources :players,   only: [:update]

  #Lets's encrypt
  get ".well-known/acme-challenge/eaMU_5AJIOniD1eBF9Roqv-2iWaSBmVpR_WXtPJL1tI" => "application#validate_ssl"
end
