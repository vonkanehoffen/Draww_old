Draww::Application.routes.draw do
  
  root :to => 'posts#index'
  
  # User Management
  resources :authentications, :users, :user_sessions

  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failure'
  get "relationship/create"
  get "relationship/destroy"

  match 'login', :to => 'user_sessions#new', :as => :login
  match 'logout', :to => 'user_sessions#destroy', :as => :logout
  
  # Posts Display
  match '/tags/:tag_name' => 'posts#index', :as => :tag_name
  match '/u/:username' => "Users#show", :as => :name_user
  match '/posts/new/:id' => 'Posts#new_child', :as => :new_child_post

  match '/posts/sweep_hotness_cache' => 'posts#sweep_hotness_cache'
  
  resources :posts do
    resources :comments
    get 'page/:page', :action => :index, :on => :collection
  end

  # Voting
  match '/posts/:id/vote' => 'posts#vote', :as => :vote

end
