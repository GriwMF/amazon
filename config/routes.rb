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

  resource :customer, only: [:show]
  resources :books, only: [:show, :index] do
    member do
      delete 'wished'
      post 'rate'
      patch 'add_wished'
    end
    collection do
      get 'filter'
      get 'home'
      get 'category/:category_id', action: 'index'
    end
  end

  resources :authors, only: [:show]
  
  resources :addresses
  resources :credit_cards
  
  resources :orders, only: [:update, :index] do
    collection do
      get 'check_out_1'
      get 'show'
      get 'recent'
      post 'add_item/:id', action: 'add_item'
      delete 'remove_item/:id', action: 'remove_item'
    end
  end

end
