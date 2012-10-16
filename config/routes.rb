Boujet02::Application.routes.draw do
  scope "(:locale)" do
      
      devise_for :users
    
      ActiveAdmin.routes(self)
    
      devise_for :admin_users, ActiveAdmin::Devise.config
      
      get '/recordings/depositor' => 'recordings#depositor'
      
      get '/recordings/:depositorid/item/' => 'recordings#item'
      
      get '/recordings' => 'recordings#index'
      
      post '/depositors/:depositorid/items/create' => 'items#create'
      
      get '/depositors/:depositorid/items/:itemid/show' => 'items#show'
      
      get '/depositors/:depositorid/items/:itemid/edit' => 'items#edit'
      
      post '/depositors/:depositorid/items/:itemid/update' => 'items#update'
      
      delete '/depositors/:depositorid/items/:itemid/destroy' => 'items#destroy'
      
      get '/depositors/:depositorid/items' => 'depositors#items'
      
      post '/depositors/create' => 'depositors#create'
      
      get '/depositors/searchindex' => 'depositors#searchindex'
      
      post '/depositors/searchbydepid' => 'depositors#searchbydepid'
      
      post '/depositors/searchbyfirstlastname' => 'depositors#searchbyfirstlastname'
      
      get '/depositors/:depositorid/edit' => 'depositors#edit'
      
      post '/depositors/:depositorid/update' => 'depositors#update'
      
      get '/depositors/:depositorid' => 'depositors#show'
      
      get '/items/searchindex' => 'items#searchindex'
      
      post '/items/searchbyitemid' => 'items#searchbyitemid'
      
      post 'items/searchbykeywords' => 'items#searchbykeywords'
      
      get '/items/:itemid/show' => 'items#show_only'
      
      get '/sellings/:sellid/show' => 'sellings#show'
      
      get '/sellings/create' => 'sellings#create'
      
      get '/sellings/showcurrent' => 'sellings#showcurrent'
      
      get '/sellings/cancelcurrentsell' => 'sellings#cancelcurrentsell'
      
      get '/sellings/currentsellpayment' => 'sellings#currentsellpayment'
      
      post '/sellings/closecurrentsell' => 'sellings#closecurrentsell'
      
      post '/sellings/addItemToCurrentSell' => 'sellings#addItemToCurrentSell'
      
      delete '/sellings/:itemid/removeFromCurrentSell' => 'sellings#removeFromCurrentSell'
      
      post '/sellings/:itemid/editItemPrice' => 'sellings#editItemPrice'
      
      get '/sellings' => 'sellings#index'
      
      get '/users/index' => 'users#index'
    
      get '/home' => 'home#index'
      
      root :to => "home#index"
      
  end
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
