Instatext::Application.routes.draw do

  root :to => "sessions#connect"
  
  match 'session/:action', :to => 'sessions'
  get "feed/index"
end
