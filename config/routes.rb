Rails.application.routes.draw do

  root 'static_pages#homepage'
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
  get 'blog', to: 'posts#index'
  get 'blog/newpost', to: 'posts#new', as: 'posts'
  get 'blog/:id', to: 'posts#show', as: 'post'
  #get 'blog/:id/edit', to: 'posts#edit', as: 'edit_post'
  #DELETE 'blog/:id' to: 'posts#update' as: 'posts'
  patch 'blog/:id', to: 'posts#update'
  delete 'blog/:id', to: 'posts#destroy'
  get 'blog/:id/edit', to: 'posts#edit', as: 'edit_post'
  post 'blog/newpost', to: 'posts#create'
  get 'about', to: 'static_pages#about'
  get 'faq', to: 'static_pages#faq'
  get 'purchase', to: 'purchases#new', as: 'new_purchase'
end
