Rails.application.routes.draw do
  devise_for :clients

  root to: "bamember/main#index"

  namespace :bamember do
    root to: "main#index"
    resources :clients, expect: :index

    get  'clients/:client_id/table/:id/search'       => 'client_tables#search'
    get  'clients/:client_id/table/:id/csv'          => 'client_tables#csv'
    post 'clients/:client_id/table/:id/csv'          => 'client_tables#csv_upload'
    get  'clients/:client_id/table/:id/csv_matching' => 'client_tables#csv_matching'
    post 'clients/:client_id/table/:id/csv_matching' => 'client_tables#csv_matching_check'
    get  'clients/:client_id/table/:id/csv_confirm'  => 'client_tables#csv_confirm'
    patch 'clients/:client_id/table/:id/csv_confirm'  => 'client_tables#csv_update'
    get  'clients/:client_id/table/:id/csv_error'    => 'client_tables#csv_error'

    get   'clients/:client_id/table/:id/edit'         => 'client_tables#edit'
    patch 'clients/:client_id/table/:id/'             => 'client_tables#update'

    get    'clients/:client_id/table/:id/new'           => 'client_tables#data_new'
    post   'clients/:client_id/table/:id/'              => 'client_tables#data_create'
    get    'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_show'
    get    'clients/:client_id/table/:id/:data_id/edit' => 'client_tables#data_edit'
    patch  'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_update'
    delete 'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_destroy'

  end
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
