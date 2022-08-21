Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  
  resources :users

  namespace :api do
    namespace :v1 do
      resources :users
      post "/token", to: "users#token"
      devise_for :users,
             controllers: {
                 sessions: 'api/v1/sessions',
                 registrations: 'api/v1/registrations'
             }
    end
  end
end
