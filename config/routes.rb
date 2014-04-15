CortezLandscaping::Application.routes.draw do

  resources :landscapers


  devise_for :users, controllers: {sessions:'sessions', confirmations:'confirmations'}

  get 'admin' => 'administrative#index'
  get 'login_requests' => 'administrative#login_requests'
  get 'system_users' => 'administrative#system_users'
  post 'approve_login_request' => 'administrative#confirm_user'
  delete 'deny_login_request' => 'administrative#deny_user'
  post 'revoke_login' => 'administrative#revoke_login'
  delete 'destroy_user' => 'administrative#deny_user'

  resources :customer_properties
  post 'remove_ownership' => 'customer_properties#remove_ownership'

  resources :properties

  resources :states

  resources :countries

  resources :customers do
    resources :customer_addresses
  end

  resources :statuses

  resources :invoices

  resources :payment_details

  get 'calendar_data'   => 'events#to_calendar'
  post 'events_remove_from_invoice' => 'events#remove_from_invoice'
  post 'events_add_to_invoice' => 'events#add_to_invoice'
  resources :events do
    resources :event_services
  end

  resources :workorders do
    resources :workorder_services
    resources :events
    resources :invoices
    post 'close', on: :member
  end

  resources :services

  get 'services_data_tables_source' => 'services#data_tables_source'
  get 'states_data_tables_source' => 'states#data_tables_source'
  get 'payment_details_data_tables_source' => 'payment_details#data_tables_source'
  get 'unconfirmed_users_data_tables_source' => 'administrative#data_tables_source_unconfirmed'
  get 'confirmed_users_data_tables_source' => 'administrative#data_tables_source_confirmed'
  get 'properties_data_tables_source' => 'properties#data_tables_source'
  get 'properties_refresh_profile' => 'properties#refresh_profile'
  get 'properties_refresh_workorders' => 'properties#refresh_workorders'
  get 'properties_load_workorder_data' => 'properties#load_workorder_data'
  get 'properties_load_property_map_data' => 'properties#load_property_map_data'
  get 'customers_load_property_data' => 'customers#load_property_data'
  get 'customers_data_tables_source' => 'customers#data_tables_source'
  get 'customers_refresh_profile' => 'customers#refresh_profile'
  get 'customers_refresh_properties' => 'customers#refresh_properties'

  get 'landscapers_data_tables_source' => 'landscapers#data_tables_source'

  get 'refresh_profile' => 'properties#refresh_profile'

  get 'workorders_data_tables_source' => 'workorders#data_tables_source'

  get 'search' => 'application#search'
  get 'workorder_search' => 'application#workorder_search'
  get 'service_search' => 'application#service_search'
  get 'customer_search' => 'application#customer_search'
  get 'property_search' => 'application#property_search'
  get 'invoice_search' => 'application#invoice_search'

  get 'ajax_loader' => 'application#ajax_loader'

  get 'change_status' => 'application#change_status'

  get 'easter_egg' => 'application#easter_egg'

  root :to => "home#index"
end