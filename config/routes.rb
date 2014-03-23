CortezLandscaping::Application.routes.draw do

  devise_for :users

  resources :customer_properties

  resources :properties

  resources :customer_addresses

  resources :states

  resources :countries

  resources :customers

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
  end

  resources :services

  get 'properties_data_tables_source' => 'properties#data_tables_source'
  get 'properties_refresh_profile' => 'properties#refresh_profile'
  get 'properties_refresh_workorders' => 'properties#refresh_workorders'
  get 'properties_load_workorder_data' => 'properties#load_workorder_data'
  get 'properties_load_property_map_data' => 'properties#load_property_map_data'

  get 'workorders_data_tables_source' => 'workorders#data_tables_source'

  get 'search' => 'application#search'
  get 'workorder_search' => 'application#workorder_search'
  get 'service_search' => 'application#service_search'
  get 'customer_search' => 'application#customer_search'
  get 'property_search' => 'application#property_search'
  get 'invoice_search' => 'application#invoice_search'

  get 'ajax_loader' => 'application#ajax_loader'
  root :to => "home#index"
end