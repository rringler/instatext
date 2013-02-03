Instatext::Application.routes.draw do

  root :to => 'sessions#new'
  resources :users do
  	resources :alerts
  end
  resources :sessions
  match 'session/connect', to: 'sessions#connect', as: 'session_connect'
  match 'session/callback', to: 'sessions#callback', as: 'session_callback'
  match 'process-post', to: 'alerts#process_post', as: 'process_post'
  match 'logout', to: 'sessions#destroy', as: 'logout'
end
