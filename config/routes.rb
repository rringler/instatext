Instatext::Application.routes.draw do

  root :to => 'sessions#new'
  resources :users
  resources :sessions
  match 'session/connect', to: 'sessions#connect', as: 'session_connect'
  match 'session/callback', to: 'sessions#callback', as: 'session_callback'
  match 'logout', to: 'sessions#destroy', as: 'logout'
end
