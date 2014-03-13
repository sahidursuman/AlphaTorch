CortezLandscaping::Application.routes.draw do

  devise_for :users

  resources :customer_properties

  resources :properties

  resources :customer_addresses

  resources :states

  resources :countries

  resources :customers

  resources :statuses

  resources :invoices do
    resources :payment_details
  end

  get 'calendar_data'   => 'events#to_calendar'
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

  get 'search' => 'application#search'
  get 'workorder_search' => 'application#workorder_search'
  get 'service_search' => 'application#service_search'
  get 'customer_search' => 'application#customer_search'
  get 'property_search' => 'properties#property_search'

  root :to => "home#index"
end