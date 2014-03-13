class WorkorderServicesController < ApplicationController
  before_filter :set_workorder_service, only: [:show, :edit, :update, :destroy]

  # GET /workorder_services
  # GET /workorder_services.json
  def index
    @workorder_services = WorkorderService.where( workorder_id: params[:workorder_id] )
    @workorder = Workorder.find(params[:workorder_id])
  end

  # GET /workorder_services/1
  # GET /workorder_services/1.json
  def show
  end

  # GET /workorder_services/new
  def new
    @workorder_service = WorkorderService.new
    @workorder = Workorder.find(params[:workorder_id])
  end

  # GET /workorder_services/1/edit
  def edit
  end

  # POST /workorder_services
  # POST /workorder_services.json
  def create
    @workorder_service = WorkorderService.new(workorder_service_params)
    @workorder = Workorder.find(params[:workorder_id])
    respond_to do |format|
      if @workorder_service.save
        format.html { redirect_to workorder_workorder_service_path(@workorder, @workorder_service), notice: 'Workorder service was successfully created.' }
        format.json { render action: 'show', status: :created, location: workorder_workorder_service_path(@workorder, @workorder_service) }
      else
        format.html { render action: 'new' }
        format.json { render json: @workorder_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workorder_services/1
  # PATCH/PUT /workorder_services/1.json
  def update
    respond_to do |format|
      if @workorder_service.update(workorder_service_params)
        format.html { redirect_to @workorder_service, notice: 'Workorder service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workorder_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workorder_services/1
  # DELETE /workorder_services/1.json
  def destroy
    @workorder_service.destroy
    respond_to do |format|
      format.html { redirect_to workorder_workorder_services_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workorder_service
      @workorder_service = WorkorderService.find(params[:id])
      @workorder = @workorder_service.workorder
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workorder_service_params
      params.require(:workorder_service).permit(:service_id, :workorder_id, :schedule, :cost)
    end
end
