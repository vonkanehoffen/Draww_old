Draww::Application.routes.draw do
  
  get "home/index"
  root :to => 'home#index'
  
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


  
  # See http://edgeguides.rubyonrails.org/routing.html#nested-resources
  # i.e. /users/1/posts
  #resources :users do
  #  resources :posts
  #end
  
  # root :to => 'posts#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
