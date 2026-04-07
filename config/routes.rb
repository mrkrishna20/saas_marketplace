Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API v1 routes
  namespace :api do
    namespace :v1 do
      post 'users/signup', to: 'users#signup'
      post 'sessions/login', to: 'sessions#login'
      post 'sessions/logout', to: 'sessions#logout'
      post 'companies', to: 'companies#create'
      get 'products', to: 'products#index'
      post 'products', to: 'products#create'
      post 'company_clients', to: 'company_clients#create'
      post 'clients/register', to: 'clients#register'
      post 'clients/login', to: 'clients#login'
      get 'clients/companies', to: 'clients#companies'
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
