class PropertiesController < ApplicationController
  before_filter :set_property, only: [:show, :edit, :update, :destroy, :refresh_profile, :refresh_workorders]
  before_filter :set_property_form, except: [:destroy]

  # GET /properties
  # GET /properties.json
  def index
    @properties = Property.all
    @property_form = NewPropertyForm.new
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
  end

  # GET /properties/new
  def new
  end

  # GET /properties/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /properties
  # POST /properties.json
  def create
    @property_form = NewPropertyForm.new

    respond_to do |format|
      if @property_form.submit(params[:property])
        format.html { redirect_to properties_path, notice: 'Property was successfully created.' }
        format.json { render json: {message:'Property successfully created!', id:@property.id}, status: :created, location:properties_path }
      else
        format.html { render action: 'index' , error: 'An error prevented the property from being created.'}
        format.json { render json: @property_form.errors, status: :unprocessable_entity }
        format.js   { render json: @property_form.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /properties/1
  # PATCH/PUT /properties/1.json
  def update
    respond_to do |format|
      if @property_form.update_attributes(params[:property])
        format.html { redirect_to @property, notice: 'Property was successfully updated.' }
        format.json { render json: {message:'Property successfully updated!', id:@property.id}, status: :accepted }
      else
        format.html { render action: 'edit' }
        format.json { render json: @property_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy
    respond_to do |format|
      format.html { redirect_to properties_url }
      format.json { head :no_content }
      format.js   { render nothing: true}
    end
  end

  def data_tables_source
    @properties = Property.all
    respond_to do |format|
      format.js {render json: {aaData:@properties.map(&:to_data_table_row)}}
    end
  end

  def refresh_profile
    respond_to do |format|
      format.js {render partial:'profile'}
    end
  end

  def refresh_workorders
    respond_to do |format|
      format.js {render partial:'workorders'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    def set_property_form
      if @property
        @customer_property = @property.current_customer_property
        @customer          = @customer_property.try(:customer)
        @property_form     = NewPropertyForm.new({property:@property, customer_property:@customer_property, customer:@customer})
      else
        @property_form     = NewPropertyForm.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:street_address_1, :street_address_2, :city, :state_id, :postal_code)
    end
end
