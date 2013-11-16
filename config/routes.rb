ShepherdEvents::Application.routes.draw do
  root 'home#index'
  resources :events, only: [:index, :show]
end
