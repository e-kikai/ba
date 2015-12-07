Rails.application.routes.draw do
  # devise_for :clients

  devise_for :bamembers,
    # controllers: { sessions: 'bamembers/sessions', },
    path:       'bamember',
    path_names: {sign_in: 'login', sign_out: 'logout'},
    only:       [:sessions]

  root to: "bamember/main#index"

  namespace :bamember do
    root      to: "main#index"
    resources :clients, expect: :index

    get    'clients/:client_id/table/:id/search'       => 'client_tables#search'
    get    'clients/:client_id/table/:id/csv'          => 'client_tables#csv'
    post   'clients/:client_id/table/:id/csv'          => 'client_tables#csv_upload'
    get    'clients/:client_id/table/:id/csv_matching' => 'client_tables#csv_matching'
    post   'clients/:client_id/table/:id/csv_matching' => 'client_tables#csv_matching_check'
    get    'clients/:client_id/table/:id/csv_confirm'  => 'client_tables#csv_confirm'
    patch  'clients/:client_id/table/:id/csv_confirm'  => 'client_tables#csv_update'
    get    'clients/:client_id/table/:id/csv_error'    => 'client_tables#csv_error'

    get    'clients/:client_id/table/:id/edit'         => 'client_tables#edit'
    patch  'clients/:client_id/table/:id/'             => 'client_tables#update'

    get    'clients/:client_id/table/:id/new'           => 'client_tables#data_new'
    post   'clients/:client_id/table/:id/'              => 'client_tables#data_create'
    get    'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_show'
    get    'clients/:client_id/table/:id/:data_id/edit' => 'client_tables#data_edit'
    patch  'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_update'
    delete 'clients/:client_id/table/:id/:data_id'      => 'client_tables#data_destroy'
  end
end
