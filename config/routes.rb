Instatext::Application.routes.draw do

  root :to => "sessions#new"
  
  match 'session/:action', to: 'sessions', as: :sessions
  get "feed/index"
end
