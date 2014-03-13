class PropertiesController < ApplicationController
  before_filter :set_property, only: [:show, :edit, :update, :destroy]

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
    @property_form = NewPropertyForm.new
  end

  # GET /properties/1/edit
  def edit
    @property_form = NewPropertyForm.new(@property)
  end

  # POST /properties
  # POST /properties.json
  def create
    @property_form = NewPropertyForm.new

    respond_to do |format|
      if @property_form.submit(params[:property])
        format.html { redirect_to properties_path, notice: 'Property was successfully created.' }
        format.json { render action: 'index', status: :created, location: properties_path }
        format.js   { render json: [{customer:@property_form.customer},
                                    {property:@property_form.property},
                                    {customer_property:@property_form.customer_property}
                                   ], status: :created, location: properties_path}
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
      if @property.update(property_params)
        format.html { redirect_to @property, notice: 'Property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @property.errors, status: :unprocessable_entity }
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
    end
  end

  def data_tables_source
    @properties = Property.all
    respond_to do |format|
      format.js {render json: {aaData:@properties.map(&:to_data_table_row)}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(:street_address_1, :street_address_2, :city, :state_id, :postal_code)
    end
end
