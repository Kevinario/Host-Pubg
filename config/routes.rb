Rails.application.routes.draw do

  root 'posts#index'
  #devise_for :users, skip: [:passwords]
  devise_for :users
  #devise_for :users, path: 'account', path_names: { sign_in: 'login', sign_out: 'logout', password: 'forgot', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'signup' }
  
  
  # devise_scope :user do
   # get 'login', to: 'devise/sessions#new'
   # get 'logout', to: 'devise/sessions#destroy'
   # get 'forgot', to: 'devise/passwords#new'
   # get 'reset', to: 'devise/passwords#edit'
   # get 'cancel', to: 'devise/registrations#cancel'
   # get 'signup', to: 'devise/registrations#new'
  # end
  
  resources :posts
end
