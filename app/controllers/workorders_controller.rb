class WorkordersController < ApplicationController
  before_filter :set_workorder, only: [:show, :edit, :update, :destroy]
  before_filter :set_customer_property, only: [:new, :edit, :create, :update]

  # GET /workorders
  # GET /workorders.json
  def index
    @workorders = Workorder.all
  end

  # GET /workorders/1
  # GET /workorders/1.json
  def show
  end

  # GET /workorders/new
  def new
    @workorder = Workorder.new
    respond_to do |format|
      format.html {
        unless params[:customer_property_id]
          redirect_to :back rescue redirect_to properties_path
        end
      }
      format.js
    end
  end

  # GET /workorders/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /workorders
  # POST /workorders.json
  def create
    @workorder = Workorder.new(workorder_params)
    respond_to do |format|
      if @workorder.save
        format.html { redirect_to @workorder, notice: 'Work Order was successfully created.' }
        format.json { render json: {message:'Work Order successfully created!', id:@customer_property.property.id}, status: :created }
        format.js   { render json: {message:'Work Order successfully created!', id:@customer_property.property.id}, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @workorder.errors, status: :unprocessable_entity }
        format.js   { render json: @workorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workorders/1
  # PATCH/PUT /workorders/1.json
  def update
    respond_to do |format|
      if @workorder.update_attributes(workorder_params)
        format.html { redirect_to @workorder, notice: 'Workorder was successfully updated.' }
        format.json { render json: {message:'Work Order successfully updated!', id:@customer_property.property.id}, status: :created }
        format.js   { render json: {message:'Work Order successfully updated!', id:@customer_property.property.id}, status: :created }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workorder.errors, status: :unprocessable_entity }
        format.js   { render json: @workorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workorders/1
  # DELETE /workorders/1.json
  def destroy
    @workorder.destroy
    respond_to do |format|
      format.html { redirect_to workorders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workorder
      @workorder = Workorder.find(params[:id])
    end

    def set_customer_property
      @customer_property = CustomerProperty.find(params[:customer_property_id] || workorder_params[:customer_property_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workorder_params
      params.require(:workorder).permit(:status_code, :name, :start_date, :customer_property_id, workorder_services_attributes:[:id, :service_id, :cost, :schedule, :single_occurrence_date, :_destroy])
    end
end
