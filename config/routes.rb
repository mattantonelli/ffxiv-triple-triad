Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  post 'locale/set', to: 'locale#update'

  resources :cards, only: [:index, :show] do
    collection do
      get 'mine', as: :my
      get 'select'
    end
  end

  get 'packs', to: 'card_packs#index'

  resources :npcs, only: [:index, :show] do
    post 'add'
    post 'remove'
    post 'defeated/update', on: :collection, to: 'npcs#update_defeated', as: :update_defeated
  end

  resources :cards, only: [] do
    post 'add'
    post 'remove'
    post 'set', on: :collection
  end

  resources :decks do
    get 'mine', as: :my, on: :collection
    post 'upvote'
    post 'downvote'
  end

  get 'users/:uid', to: 'users#show', as: :user
  get 'user/settings', to: 'users#edit'
  post 'user/settings', to: 'users#update'
  get 'user/import', to: 'users#import'
  post 'user/import', to: 'users#submit'

  namespace :api do
    %w(npcs cards packs decks).each do |model|
      resources model, only: [:index, :show], defaults: { format: :json }
    end

    resources :users, only: :show
  end

  get 'api/docs', to: redirect('https://documenter.getpostman.com/view/1779678/TzXzDHRR')

  get 'commands', to: 'static#commands'
  post 'discord/interactions'

  namespace :admin do
    resources :users, only: :index
    resources :npcs, only: [:index, :edit, :update]
    resources :cards, only: [:index, :edit, :update] do
      delete 'delete_sources'
    end
  end

  get '404', to: 'static#not_found', as: :not_found
  match "api/*path", via: :all, to: -> (_) { [404, { 'Content-Type' => 'application/json' },
                                              ['{"status": 404, "error": "Not found"}'] ] }
  match "*path", via: :all, to: redirect('404')

  # Quick 404 for missing images
  scope format: true, constraints: { format: 'png' } do
    get "/*missing", to: proc { [404, {}, ['']] }
  end

  root 'static#home'
end
