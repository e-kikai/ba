Rails.application.routes.draw do
  # devise_for :clients

  devise_for :bamembers,
    # controllers: { sessions: 'bamembers/sessions', },
    path:       'bamember',
    path_names: {sign_in: 'login', sign_out: 'logout'},
    only:       [:sessions]

  # root to: "bamember/main#index"

  devise_for :clients,
    path:       'client',
    path_names: {sign_in: 'login', sign_out: 'logout'},
    only:       [:sessions]

  # user pages
  root to: "client#index"
  get   'client/edit_password' => 'client#edit_password'
  patch 'client/edit_password' => 'client#update_password'

  get 'client_tables/:id/search'   => 'client_tables#search'
  get 'client_tables/:id/sum'      => 'client_tables#sum'
  get 'client_tables/:id/rfm'      => 'client_tables#rfm'
  get 'client_tables/:id/:data_id' => 'client_tables#data_show'

  # BA member pages
  namespace :bamember do
    root      to: "main#index"
    resources :clients, expect: :index
    get    'clients/:id/edit_password' => 'clients#edit_password'
    patch  'clients/:id/edit_password' => 'clients#update_password'

    get    'clients/:client_id/table/new'              => 'client_tables#new'
    post   'clients/:client_id/table/'                 => 'client_tables#create'
    get    'clients/:client_id/table/:id/search'       => 'client_tables#search'
    get    'clients/:client_id/table/:id/csv'          => 'client_tables#csv'
    post   'clients/:client_id/table/:id/csv'          => 'client_tables#csv_upload'
    get    'clients/:client_id/table/:id/csv_matching' => 'client_tables#csv_matching'
    post   'clients/:client_id/table/:id/csv_matching' => 'client_tables#csv_matching_check'
    get    'clients/:client_id/table/:id/csv_confirm'  => 'client_tables#csv_confirm'
    patch  'clients/:client_id/table/:id/csv_confirm'  => 'client_tables#csv_update'
    get    'clients/:client_id/table/:id/csv_error'    => 'client_tables#csv_error'

    get    'clients/:client_id/table/:id/relation'          => 'client_tables#relation'
    get    'clients/:client_id/table/:id/relation_error'    => 'client_tables#relation_error'
    post   'clients/:client_id/table/:id/relation_confirm'  => 'client_tables#relation_confirm'
    patch  'clients/:client_id/table/:id/relation_do'       => 'client_tables#relation_do'

    get    'clients/:client_id/table/:id/bulk_delete'        => 'client_tables#data_bulk_delete'
    get    'clients/:client_id/table/:id/bulk_delete_check'  => 'client_tables#data_bulk_delete_check'
    delete 'clients/:client_id/table/:id/bulk_delete'        => 'client_tables#data_bulk_destroy'

    get    'clients/:client_id/table/:id/sum'          => 'client_tables#sum'
    get    'clients/:client_id/table/:id/rfm'          => 'client_tables#rfm'

    get    'clients/:client_id/table/:id/edit'         => 'client_tables#edit'
    patch  'clients/:client_id/table/:id/'             => 'client_tables#update'
    delete 'clients/:client_id/table/:id/'             => 'client_tables#destroy'

    get    'clients/:client_id/table/:id/new'           => 'client_tables#data_new'
    post   'clients/:client_id/table/:id/'              => 'client_tables#data_create'
    get    'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_show'
    get    'clients/:client_id/table/:id/:data_id/edit' => 'client_tables#data_edit'
    patch  'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_update'
    delete 'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_destroy'
  end
end
