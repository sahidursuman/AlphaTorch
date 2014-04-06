class ServicesController < ApplicationController
  before_filter :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new
  def new
    @service = Service.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /services/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
        format.json { render json:{message:'Service was successfully created.'}, status: :created, location: @service }
      else
        format.html { render action: 'new' }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update_attributes(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render json:{message:'Service was successfully updated.'}}
      else
        format.html { render action: 'edit' }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url }
      format.json { render json:{message:'Service has been deleted.'} }
      format.js   { render json:{message:'Service has been deleted.', status: :ok}}
    end
  end

  def data_tables_source
    @services = Service.all
    respond_to do |format|
      format.js {render json: {aaData:@services.map(&:to_data_table_row)}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:name, :base_cost)
    end
end
