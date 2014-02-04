FirstModel::Application.routes.draw do
  devise_for :customers
  root 'books#index'
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

  resource :customer, only: [:show, :edit, :update]
  resources :books do
    member do
      delete "author/:author_id", action: "un_author"
      delete "category/:category_id", action: "un_category"
      delete "wished"
      post "assign_author"
      post "assign_category"
      post "rate"
      patch "add_wished"
    end
    collection do
      post "filter"
    end
  end

  namespace :ratings do
    get "check_ratings"
    patch "approve/:id", action: "approve"
    delete "decline/:id", action: "destroy"
  end

  resources :authors
  resources :categories
  
  resources :addresses
  resources :credit_cards
  
  resources :orders, except: [:destroy] do
    member do
      patch 'ship'
      patch 'cancel'
    end
    
    collection do
      post "add_item/:id", action: "add_item"
      delete "remove_item/:id", action: "remove_item"
    end
  end

end
