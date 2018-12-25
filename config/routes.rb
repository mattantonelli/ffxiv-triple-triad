Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :cards, only: [:index, :show] do
    collection do
      get 'mine', as: :my
      get 'select'
    end
  end

  resources :card_packs, only: :index
  resources :npcs, only: [:index, :show]

  resources :cards, only: [] do
    post 'add'
    post 'remove'
    post 'set', on: :collection
  end

  get 'user/settings', to: 'users#edit'
  post 'user/settings', to: 'users#update'

  namespace :api do
    %w(npcs cards packs).each do |model|
      resources model, only: [:index, :show], defaults: { format: :json }
    end

    resources :users, only: :show
  end

  get '404', to: 'home#not_found'
  match "api/*path", via: :all, to: -> (_) { [404, { 'Content-Type' => 'application/json' },
                                              ['{"status": 404, "error": "Not found"}'] ] }
  match "*path", via: :all, to: redirect('404')

  root 'home#index'
end
