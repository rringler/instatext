Instatext::Application.routes.draw do

  root :to => 'sessions#new'
  resources :users do
  	resources :alerts
  end
  resources :sessions
  match 'connect', to: 'sessions#connect', as: 'connect'
  match 'auth_callback', to: 'sessions#auth_callback', as: 'auth_callback'
  match 'sub_callback', to: 'alerts#sub_callback_get', via: :get
  match 'sub_callback', to: 'alerts#sub_callback_post', via: :post
  match 'logout', to: 'sessions#destroy', as: 'logout'

  # Temp while debugging subscription creation
  match 'create_sub', to: 'alerts#create_sub'
  match 'list_subs', to: 'alerts#list_subs'
end
