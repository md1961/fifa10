ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.admin_index 'admin' , :controller => 'admin', :action => 'index'
  map.login       'login' , :controller => 'admin', :action => 'login'
  map.logout      'logout', :controller => 'admin', :action => 'logout'

  map.roster_chart       'roster_chart'       , :controller => 'players', :action => 'roster_chart'
  map.depth_chart        'depth_chart'        , :controller => 'players', :action => 'depth_chart'
  map.top_attribute_list 'top_attribute_list' , :controller => 'players', :action => 'top_attribute_list'

  map.filter_with_series 'filter_with_series' , :controller => 'matches', :action => 'filter_with_series'
  map.choose_to_list     'choose_to_list'     , :controller => 'matches', :action => 'choose_to_list'
  map.filter_on_list     'filter_on_list'     , :controller => 'matches', :action => 'filter_on_list'
  map.set_is_font_bold   'set_is_font_bold'   , :controller => 'matches', :action => 'set_is_font_bold'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
  map.resources :countries , :requirements => {:id => /\d+/}
  map.resources :chronicles, :requirements => {:id => /\d+/}, :member => {:open => :get, :close => :get}
  map.resources :teams     , :requirements => {:id => /\d+/}
  map.resources :seasons   , :requirements => {:id => /\d+/}
  map.resources :matches   , :requirements => {:id => /\d+/}
  map.resources :players   , :requirements => {:id => /\d+/}

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => 'admin', :action => 'login'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
