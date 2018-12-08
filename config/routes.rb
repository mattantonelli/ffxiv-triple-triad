Rails.application.routes.draw do
  resources :cards, only: :index
  resources :card_packs, only: :index

  root 'home#index'
end
