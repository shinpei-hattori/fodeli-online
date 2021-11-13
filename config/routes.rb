Rails.application.routes.draw do
  get    :login,     to: 'sessions#new'
  post   :login,     to: 'sessions#create'
  delete :logout,    to: 'sessions#destroy'
  get :signup,       to: 'users#new'
  resources :users
  root 'static_pages#home'
  get :about,        to: 'static_pages#about'
end
