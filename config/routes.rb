Rails.application.routes.draw do
  devise_for :users
    
  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  
  resources :roles
  
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  #root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :users
      post "/login", to: "users#login"
      get "/auto_login", to: "users#auto_login" 
      devise_for :users,
             controllers: {
                 sessions: 'api/v1/sessions',
                 registrations: 'api/v1/registrations'
             }
    end
  end
end
