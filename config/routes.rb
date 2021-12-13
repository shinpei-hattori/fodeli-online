Rails.application.routes.draw do
  get    :login,     to: 'sessions#new'
  post   :login,     to: 'sessions#create'
  delete :logout,    to: 'sessions#destroy'
  get :signup,       to: 'users#new'
  resources :users do
    member do
      get :following, :followers, :dmlists
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :tweets
  root 'static_pages#home'
  get :about,        to: 'static_pages#about'
  post   "likes/:tweet_id/create"  => "likes#create"
  delete "likes/:tweet_id/destroy" => "likes#destroy"
  resources :comments, only: [:create, :destroy]
  resources :dm_messages, only: [:create,:destroy]
  resources :dm_rooms, only: [:create,:show]



end