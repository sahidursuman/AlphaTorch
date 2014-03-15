class CustomersController < ApplicationController
  before_filter :set_customer, only: [:show, :edit, :update, :destroy, :refresh_profile, :refresh_properties]
  before_filter :set_customer_form, except: [:destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all
    @customer_form = NewCustomerForm.new
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
  end

  # GET /customers/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /customers
  # POST /customers.json
  def create
    #@customer_form = NewCustomerForm.new

    respond_to do |format|
      if @customer_form.submit(params[:customer])
        format.html { redirect_to customers_path, notice: 'Customer was successfully created.' }
        format.json { render json: {message: 'Customer Successfully Created'}, status: :created, location: @customer }
      else
        format.html { render action: 'new' }
        format.json {
          p 'CUSTOMER FORM ERRORS'
          p @customer_form.errors
          render json: @customer_form.errors, status: :unprocessable_entity
        }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer_form.update_attributes(params[:customer])
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render json: {message: 'Customer successfully updated.', id:@customer.id}, status: :accepted }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_form.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end

  def data_tables_source
    @customers = Customer.all
    respond_to do |format|
      format.js {render json: {aaData:@customers.map(&:to_data_table_row)}}
    end
  end

  def load_property_data
    @property = Property.find(params[:property_id])
    respond_to do |format|
      format.html {render partial:'property_details'}
    end
  end

  def refresh_profile
    respond_to do |format|
      format.html {render partial:'profile'}
    end
  end

  def refresh_properties
    respond_to do |format|
      format.html {render partial:'properties'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def set_customer_form
      if @customer
        @customer_form = NewCustomerForm.new({customer:@customer})
      else
        @customer_form = NewCustomerForm.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:status_code, :first_name, :middle_initial, :last_name, :primary_phone, :secondary_phone, :email, :description)
    end
end
