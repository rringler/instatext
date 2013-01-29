Instatext::Application.routes.draw do

  root :to => "sessions#new"
  resources :users, only: [:new, :create]

  match 'session/:action', to: 'sessions', as: :sessions
  get "feed/index", as: :feed
end
