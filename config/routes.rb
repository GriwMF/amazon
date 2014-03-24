FirstModel::Application.routes.draw do
  devise_for :customers, :controllers => { :omniauth_callbacks => "customers/omniauth_callbacks" }
  
  root 'books#home'
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
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

  resource :customer, only: [:show] do
    post 'ship_update', action: 'ship_create'
    patch 'ship_update'
    post 'bill_update', action: 'bill_create'
    patch 'bill_update'
  end

  resources :books, only: [:show, :index] do
    member do
      delete 'wished'
      post 'rate'
      patch 'add_wished'
    end
    collection do
      get 'home'
      get 'category/:category_id', action: 'index'
    end
  end

  resources :authors, only: [:show]
  
  resources :orders, only: [:index, :show] do
    collection do
      get 'check_out/:step', action: 'check_out', :as => "check_out"
      get 'cart'
      get 'recent'
      get 'complete'
      post 'add_item/:id', action: 'add_item'
      patch 'update'
      patch 'addresses'
      patch 'delivery'
      patch 'credit_card'
      delete 'remove_item/:id', action: 'remove_item'
      delete 'destroy', :as => "delete"
    end
  end

end
