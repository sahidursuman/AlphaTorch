class CustomerPropertiesController < ApplicationController
  before_filter :set_customer_property, only: [:show, :edit, :update, :destroy]

  # GET /customer_properties
  # GET /customer_properties.json
  def index
    @customer_properties = CustomerProperty.all
  end

  # GET /customer_properties/1
  # GET /customer_properties/1.json
  def show
  end

  # GET /customer_properties/new
  def new
    @customer_property = CustomerProperty.new
  end

  # GET /customer_properties/1/edit
  def edit
  end

  # POST /customer_properties
  # POST /customer_properties.json
  def create
    @customer_property = CustomerProperty.new(customer_property_params)

    respond_to do |format|
      if @customer_property.save
        format.html { redirect_to @customer_property, notice: 'Customer property was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer_property }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_properties/1
  # PATCH/PUT /customer_properties/1.json
  def update
    respond_to do |format|
      if @customer_property.update(customer_property_params)
        format.html { redirect_to @customer_property, notice: 'Customer property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_properties/1
  # DELETE /customer_properties/1.json
  def destroy
    @customer_property.destroy
    respond_to do |format|
      format.html { redirect_to customer_properties_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_property
      @customer_property = CustomerProperty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_property_params
      params.require(:customer_property).permit(:customer_id, :property_id, :owner)
    end
end
