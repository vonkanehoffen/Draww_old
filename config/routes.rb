Draww::Application.routes.draw do
  resources :users, :user_sessions
  
  # /login & /logout
  match 'login', :to => 'user_sessions#new', :as => :login
  # the above is equivalent to (rails 2) I think:
  # map.login   'login',  :controller => 'user_sessions', :action => 'new'
  match 'logout', :to => 'user_sessions#destroy', :as => :logout
    
  match '/user/:username' => "Users#show", :as => :name_user
  resources :posts do
    resources :comments
    get 'page/:page', :action => :index, :on => :collection
  end
  
  # See http://edgeguides.rubyonrails.org/routing.html#nested-resources
  # i.e. /users/1/posts
  resources :users do
    resources :posts
  end
  
  get "home/index"
  # root :to => 'posts#index'
  root :to => 'home#index'

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
