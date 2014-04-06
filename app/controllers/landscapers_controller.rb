class LandscapersController < ApplicationController
  before_filter :set_landscaper, only: [:show, :edit, :update, :destroy]

  # GET /landscapers
  # GET /landscapers.json
  def index
    @landscapers = Landscaper.all
  end

  # GET /landscapers/1
  # GET /landscapers/1.json
  def show
  end

  # GET /landscapers/new
  # GET /landscapers/new.json
  def new
    @landscaper = Landscaper.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /landscapers/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /landscapers
  # POST /landscapers.json
  def create
    @landscaper = Landscaper.new(landscaper_params)

    respond_to do |format|
      if @landscaper.save
        format.html { redirect_to landscapers_path, notice: 'Landscaper was successfully created.' }
        format.json { render json: {message:'Landscaper successfully created!'}, status: :created, location: @landscaper }
        #format.js   { render json: {message:'Landscaper successfully created!'}, status: :created, location: @landscaper }
      else
        format.html { render action: "new" }
        format.json { render json: @landscaper.errors, status: :unprocessable_entity }
        #format.js   { render json: @landscaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /landscapers/1
  # PATCH/PUT /landscapers/1.json
  def update
    respond_to do |format|
      if @landscaper.update_attributes(landscaper_params)
        format.html { redirect_to @landscaper, notice: 'Landscaper was successfully updated.' }
        format.json { render json: {message:'Landscaper successfully created!'}, status: :created, location: @landscaper }
        #format.js   { render json: {message:'Landscaper successfully created!'}, status: :created, location: @landscaper }
      else
        format.html { render action: "edit" }
        format.json { render json: @landscaper.errors, status: :unprocessable_entity }
        #format.js   { render json: @landscaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /landscapers/1
  # DELETE /landscapers/1.json
  def destroy
    @landscaper.destroy
    respond_to do |format|
      format.html { redirect_to landscapers_url }
      format.json { render json: {message:'Landscaper has been deleted.'} }
      format.js   { render json: {message:'Landscaper has been deleted.', status: :ok}}
    end
  end

  def data_tables_source
    @landscapers = Landscaper.all
    respond_to do |format|
      format.js {render json: {aaData:@landscapers.map(&:to_data_table_row)}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_landscaper
      @landscaper = Landscaper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def landscaper_params
      params.require(:landscaper).permit(:description, :email, :first_name, :last_name, :middle_initial, :primary_phone, :rating, :secondary_phone, :status_code)
    end
end
