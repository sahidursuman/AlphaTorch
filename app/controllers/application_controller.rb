class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  def search
    search_term = params[:term]
    results = Search.new(search_term).results
    render :json => results
  end

  def workorder_search
    search_term = params[:term]
    results = Search.new(search_term).results.group_by {|k| k[:category]}['Workorders']
    render :json => results
  end

  def service_search
    search_term = params[:term]
    results = Search.new(search_term).results.group_by {|k| k[:category]}['Services']
    render :json => results
  end

  def customer_search
    search_term = params[:term]
    results = Search.new(search_term).results.group_by {|k| k[:category]}['Customers']
    render :json => results
  end

  def property_search
    search_term = params[:term]
    results = Search.new(search_term).results.group_by {|k| k[:category]}['Properties']
    render :json => results
  end

  def invoice_search
    search_term = params[:term]
    results = Search.new(search_term).results.group_by {|k| k[:category]}['Invoices']
    render :json => results
  end

  def ajax_loader
    render partial: 'shared/ajax_loader'
  end

  def change_status
    object = params[:class]
    klass = object.constantize
    if klass.attribute_names.include?('status_code')
      id = params[:id]
      object = klass.find(id)
      status = params[:status]
      object.change_status(status)
      render json: {message:"Customer Status Changed To #{status}"}
    else
      false
    end
  end

end
