Rails.application.routes.draw do
  root 'launchpad#show'

  resources :attacks,   only: [:create]
end
