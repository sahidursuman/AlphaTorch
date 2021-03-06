class EventsController < ApplicationController
  before_filter :set_event, only: [:show, :edit, :update, :destroy, :remove_from_invoice, :add_to_invoice]

  # GET /events
  # GET /events.json
  def index
    @events = params[:workorder_id] ? Event.where(workorder_id: params[:workorder_id]) : Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new(all_day:true)
    if params[:start]
      @event.start = params[:start].to_datetime.midnight + 5.hours
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /events/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: {message:'Event was successfully created.'}, status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render json: {message:'Event was successfully updated.'}, status: :created, location: @event }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { render json: {message:'Event was deleted.'} }
    end
  end

  #data for full calendar
  def to_calendar
    from_date = DateTime.strptime(params[:start],'%s').strftime("%Y-%m-%d")
    to_date   = DateTime.strptime(params[:end],'%s').strftime("%Y-%m-%d")

    respond_to do |format|
      format.js {render json: Event.to_calendar(from_date, to_date)}
    end
  end

  def remove_from_invoice
    respond_to do |format|
      if @event.remove_from_invoice
        format.json { render json: {message: 'Removed From Invoice.'}, status: :ok}
      else
        format.json { render json: {message: 'Unable To Remove Item'}, status: :unprocessable_entity}
      end
    end
  end

  def add_to_invoice
    respond_to do |format|
      if @event.add_to_invoice(params[:invoice_id])
        format.json { render json: {message: 'Added To Invoice.'}, status: :ok}
      else
        format.json { render json: {message: 'Unable To Add Item'}, status: :unprocessable_entity}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:status_code, :workorder_id, :name, :cost, :start, :end, :all_day, :comment, event_services_attributes:[:id, :event_id, :service_id, :cost, :cost_dollars, :_destroy])
    end
end
