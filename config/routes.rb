Rails.application.routes.draw do
  devise_for :users
  resources :customers
  root 'customers#index'
end
