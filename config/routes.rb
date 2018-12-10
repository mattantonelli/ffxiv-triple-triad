Rails.application.routes.draw do
  resources :cards, only: :index
  resources :card_packs, only: :index
  resources :npcs, only: [:index, :show]

  root 'home#index'
end
