Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  root 'launchpad#show'
end
