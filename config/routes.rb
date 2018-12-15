Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :cards, only: [:index, :show] do
    collection do
      get 'mine', as: :my
    end
  end

  resources :card_packs, only: :index
  resources :npcs, only: [:index, :show]

  resources :users, only: [] do
    resources :cards, only: [] do
      post 'add'
      post 'remove'
    end
  end

  root 'home#index'
end
