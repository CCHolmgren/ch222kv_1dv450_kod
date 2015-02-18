Rails.application.routes.draw do

  root "users#index"


  #get 'api_applications', :to => "api_applications#index", :as => "api_applications"

  #post 'api_applications', :to => "api_applications#create"

  #get 'api_applications/new', :to => "api_applications#new", :as => "new_api_application"

  #get 'api_applications/:id', :as => "api_application", :to => "api_applications#show"



  #get 'api_applications/:id/edit', :to => "api_applications#edit"

  #patch 'api_applications/:id', :to => "api_applications#update"

  #put 'api_applications/:id', :to => "api_applications#update"

  #delete 'api_applications/:id', :to => "api_applications#destroy"
  resources :api_applications
  get "/register", :to => "users#new", :as => "registration"
  resources :users

  get "/api/v1/user", :to => "api#index"

  get "/login", to: "users#login", as: "login"
  post "/login", to: "users#login"
  post "/logout", :to => "users#logout_post", :as => "logout"
  get "/logout", :to => "users#logout_post"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
