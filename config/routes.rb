Rails.application.routes.draw do
  get    :login,     to: 'sessions#new'
  post   :login,     to: 'sessions#create'
  delete :logout,    to: 'sessions#destroy'
  get :signup,       to: 'users#new'
  get :user_search, to: 'users#search'
  resources :users do
    member do
      get :following, :followers, :dmlists ,:chatlists
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :tweets
  get :tweet_search, to: 'tweets#search'
  root 'static_pages#home'
  get :about,        to: 'static_pages#about'
  post   "likes/:tweet_id/create"  => "likes#create"
  delete "likes/:tweet_id/destroy" => "likes#destroy"
  resources :comments, only: [:create, :destroy]
  resources :dm_messages, only: [:create,:destroy]
  resources :dm_rooms, only: [:index,:create,:show]
  resources :chat_rooms, only: [:index,:create,:show,:destroy]
  resources :chat_posts, only: [:create,:destroy]
  resources :notifications, only: :index
end