Rails.application.routes.draw do
  get 'events/index'

  get 'events/show'

  get 'events/new'

  get 'events/edit'

  get 'events/destroy'

  get 'positions/index'

  get 'positions/show'

  get 'errors/file_not_found'

  get 'errors/unprocessable'

  get 'errors/internal_server_error'

  match "/404", to: "errors#file_not_found", via: :all
  match "/422", to: "errors#unprocessable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  root "sessions#index"

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

  scope 'api' do
    scope 'v1' do

      get "/events/search", :to => "events#search"
      get "/events/location", :to => "events#proximity"
      resources :tags
      resources :events
      resources :positions
      resources :users
      get "/events/user/:user_id", :to => "events#select_on_user"
      get "/tags/:id/events/", :to => "tags#select_on_tag"
      get "/users/:id/events/", :to => "users#select_on_user"
      #get "/users/:id", :to => "api#index"
    end
  end

  get "/login", to: "sessions#login", as: "login"
  post "/login", to: "sessions#login"
  post "/logout", :to => "sessions#logout", :as => "logout"
  get "/logout", :to => "sessions#logout"

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
