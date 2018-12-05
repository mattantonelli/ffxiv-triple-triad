Rails.application.routes.draw do
  resources :cards, only: :index

  root 'home#index'
end
