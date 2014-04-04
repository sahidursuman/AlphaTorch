# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140404193957) do

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customer_addresses", :force => true do |t|
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "postal_code"
    t.integer  "customer_id"
    t.string   "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "customer_properties", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "property_id"
    t.boolean  "owner"
    t.integer  "status_code", :default => 1011
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "customers", :force => true do |t|
    t.integer  "status_code",     :default => 1011
    t.string   "first_name"
    t.string   "middle_initial"
    t.string   "last_name"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.string   "email"
    t.string   "description"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "event_services", :force => true do |t|
    t.integer  "service_id"
    t.integer  "event_id"
    t.integer  "workorder_service_id"
    t.integer  "cost"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "event_services", ["workorder_service_id"], :name => "index_event_services_on_workorder_service_id"

  create_table "events", :force => true do |t|
    t.integer  "workorder_id"
    t.boolean  "all_day"
    t.datetime "start"
    t.datetime "end"
    t.string   "name"
    t.integer  "invoice_id"
    t.integer  "status_code",  :default => 1007
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "invoices", :force => true do |t|
    t.integer  "status_code",    :default => 1000
    t.date     "invoice_date"
    t.date     "due_date"
    t.integer  "invoice_amount", :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "payment_details", :force => true do |t|
    t.date     "payment_date"
    t.string   "cc_processing_code"
    t.string   "check_name"
    t.integer  "check_number"
    t.string   "check_routing"
    t.integer  "cash_subtotal"
    t.integer  "check_subtotal"
    t.integer  "cc_subtotal"
    t.integer  "invoice_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "cc_type"
    t.string   "cc_name"
    t.string   "cash_name"
  end

  create_table "properties", :force => true do |t|
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "postal_code"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "map_data"
  end

  add_index "properties", ["street_address_1", "street_address_2", "city", "state_id"], :name => "unique_address", :unique => true

  create_table "services", :force => true do |t|
    t.string   "name"
    t.integer  "base_cost"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "states", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "statuses", :force => true do |t|
    t.integer  "status_code"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workorder_services", :force => true do |t|
    t.integer  "service_id"
    t.integer  "workorder_id"
    t.datetime "single_occurrence_date"
    t.text     "schedule"
    t.integer  "cost"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "workorders", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.integer  "status_code",          :default => 1000
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "customer_property_id"
  end

  add_index "workorders", ["customer_property_id"], :name => "index_workorders_on_customer_property_id"

end
