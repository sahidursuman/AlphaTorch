class PaymentDetailsController < ApplicationController
  before_filter :set_payment_detail, only: [:show, :edit, :update, :destroy]
  before_filter :set_invoice, only: [:new, :edit]
  # GET /payment_details
  # GET /payment_details.json
  def index
    @payment_details = PaymentDetail.all
  end

  # GET /payment_details/1
  # GET /payment_details/1.json
  def show
  end

  # GET /payment_details/new
  def new
    @payment_detail = PaymentDetail.new
  end

  # GET /payment_details/1/edit
  def edit
    @options = {
        method: @payment_detail.payment_method,
        #name: @payment_detail.name,
        old_payment_amount: @payment_detail.amount
        #number: @payment_detail.check_number,
        #routing: @payment_detail.check_routing,
        #processing: @payment_detail.cc_processing_code,
        #cc_type: @payment_detail.cc_type
    }
    respond_to do |format|
      format.js
    end
  end

  # POST /payment_details
  # POST /payment_details.json
  def create
    @payment_detail = PaymentDetail.new(payment_detail_params)
    respond_to do |format|
      if @payment_detail.save
        @property = set_property
        format.html { redirect_to @payment_detail, notice: 'Payment detail was successfully created.' }
        format.json {
          unless @property
            render json: {message:'Payment Created Successfully!'}, status: :created, location: @payment_detail
          else
            render json: {message:'Payment Created Successfully!', id:@property.id}, status: :created, location: @payment_detail
          end
        }
      else
        format.html { render action: 'new' }
        format.json { render json: @payment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_details/1
  # PATCH/PUT /payment_details/1.json
  def update
    respond_to do |format|
      if @payment_detail.update_attributes(payment_detail_params)
        format.html { redirect_to @payment_detail, notice: 'Payment detail was successfully updated.' }
        format.json { render json: {message:'Payment Updated Successfully!'} }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_details/1
  # DELETE /payment_details/1.json
  def destroy
    @payment_detail.destroy
    respond_to do |format|
      format.html { redirect_to payment_details_url }
      format.js { render json:{message:'Payment Has Been Deleted.'} }
    end
  end

  def data_tables_source
    @payment_details = PaymentDetail.all
    respond_to do |format|
      format.js {render json: {aaData:@payment_details.map(&:to_data_table_row)}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_detail
      @payment_detail = PaymentDetail.find(params[:id])
    end

    def set_property
      Property.find_by_sql("SELECT DISTINCT properties.*
                            FROM properties, customer_properties, workorders, events, invoices, payment_details
                            WHERE customer_properties.property_id = properties.id
                            AND workorders.customer_property_id = customer_properties.id
                            AND events.workorder_id = workorders.id
                            AND events.invoice_id = invoices.id
                            AND payment_details.invoice_id = invoices.id
                            AND payment_details.id = #{@payment_detail.id}
                            ").first
    end

    def set_invoice
      id = params[:invoice_id] ? params.delete(:invoice_id) : nil
      @invoice = id ? Invoice.find(id) : nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_detail_params
      params.require(:payment_detail).permit(:payment_date, :cc_processing_code, :check_name, :check_number, :check_routing, :cc_name, :cc_type, :cash_name, :cash_subtotal, :check_subtotal, :cc_subtotal, :cash_subtotal_dollars, :check_subtotal_dollars, :cc_subtotal_dollars, :invoice_id, :old_payment_amount, :method)
    end
end
