Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "clients#index", as: :authenticated_root
  end

  unauthenticated :user do
    devise_scope :user do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  resources :clients do 
    resources :projects do 
      resources :invoices do 
        member do 
          post :send_email
        end
      end
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Billing routes
  get  'billing',           to: 'billing#show'
  post 'billing/checkout',  to: 'billing#checkout'
  post 'billing/webhook',   to: 'billing#webhook'

   # Subscription management routes (new)
  resource :subscription, only: [:show] do
    post :create_checkout_session, on: :collection
    post :cancel, on: :collection
  end

  # Sidekiq Web UI (admin background jobs dashboard)
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end