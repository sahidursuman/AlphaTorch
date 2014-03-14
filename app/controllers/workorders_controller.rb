class WorkordersController < ApplicationController
  before_filter :set_workorder, only: [:show, :edit, :update, :destroy]

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
    if params[:customer_property_id]
      @customer_property = CustomerProperty.find(params[:customer_property_id])
    else
      #redirect_to properties_path
    end

    respond_to do |format|
      format.html
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
        format.html { redirect_to @workorder, notice: 'Workorder was successfully created.' }
        format.json { render action: 'show', status: :created, location: @workorder }
      else
        format.html { render action: 'new' }
        format.json { render json: @workorder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workorders/1
  # PATCH/PUT /workorders/1.json
  def update
    respond_to do |format|
      if @workorder.update_attributes(workorder_params)
        format.html { redirect_to @workorder, notice: 'Workorder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workorder.errors, status: :unprocessable_entity }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def workorder_params
      params.require(:workorder).permit(:name, :start_date, :customer_property_id, workorder_services_attributes:[:id, :service_id, :cost, :schedule, :_destroy])
    end
end
