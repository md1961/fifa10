Fifa10::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match 'admin' => 'admin#index' , :as => :admin_index
  match 'login' => 'admin#login' , :as => :login
  match 'logout'=> 'admin#logout', :as => :logout

  match 'roster_chart'       => 'roster_charts#index'       , :as => :roster_chart
  match 'depth_chart'        => 'players#depth_chart'       , :as => :depth_chart
  match 'top_attribute_list' => 'players#top_attribute_list', :as => :top_attribute_list
  match 'disablement_check'  => 'players#disablement_check' , :as => :disablement_check

  match 'players/filter_with/:filter'     => 'players#filter_with'        , :as => :filter_players_with
  match 'players/:id/remove_from_rosters/'=> 'players#remove_from_rosters', :as => :remove_from_rosters

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :countries , :requirements => {:id => /\d+/}
  resources :teams     , :requirements => {:id => /\d+/}
  resources :seasons   , :requirements => {:id => /\d+/}
  resources :formations, :requirements => {:id => /\d+/}

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
  resources :chronicles, :requirements => {:id => /\d+/} do
    member do
      get :open
      get :close
    end
  end

  resources :matches   , :requirements => {:id => /\d+/} do
    collection do
      get :series_filter
      get :player_choose
      get :player_filter
      get :set_font
    end
  end

  resources :players   , :requirements => {:id => /\d+/} do
    collection do
      get :choose_filter
      post :filter_command
      post :filter
      get :choose_sort
      post :prepare_sort
      get :clear_sort
      get :attribute_legend
    end
  end

  resources :roster_charts, :only => [:index] do
    collection do
      get :pick_injury
      get :undo_pick_injury
      get :clear_injury
      get :revise_lineup
      get :edit_roster
      get :apply_formation
    end
  end

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
  # root :to => "welcome#index"
  root :to => 'admin#login'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
