class EventServicesController < ApplicationController
  before_filter :set_event_service, only: [:show, :edit, :update, :destroy]

  # GET /event_services
  # GET /event_services.json
  def index
    @event_services = EventService.all.where(event_id: params[:event_id])
    @event = Event.find(params[:event_id])
  end

  # GET /event_services/1
  # GET /event_services/1.json
  def show
  end

  # GET /event_services/new
  def new
    @event_service = EventService.new
  end

  # GET /event_services/1/edit
  def edit
  end

  # POST /event_services
  # POST /event_services.json
  def create
    @event_service = EventService.new(event_service_params)

    respond_to do |format|
      if @event_service.save
        format.html { redirect_to @event_service, notice: 'Event service was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event_service }
      else
        format.html { render action: 'new' }
        format.json { render json: @event_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_services/1
  # PATCH/PUT /event_services/1.json
  def update
    respond_to do |format|
      if @event_service.update_attributes(event_service_params)
        format.html { redirect_to @event_service, notice: 'Event service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_services/1
  # DELETE /event_services/1.json
  def destroy
    @event_service.destroy
    respond_to do |format|
      format.html { redirect_to event_services_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_service
      @event_service = EventService.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_service_params
      params.require(:event_service).permit(:service_id, :event_id, :cost, :_destroy)
    end
end
