Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'} 
  resources :customers
  root 'customers#index'
  get 'customers/index', as: 'user_root'
end
