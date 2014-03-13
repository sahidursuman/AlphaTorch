class NewPropertyForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  delegate :street_address_1,:street_address_2,:city,:state_id,:postal_code, to: :property
  delegate :first_name,:middle_initial,:last_name,:primary_phone, :secondary_phone, to: :customer

  attr :customer_id

  validates_presence_of :street_address_1, :city, :state_id, :postal_code
  validate  :unique_street_address
  validates_presence_of :first_name, :last_name, unless: lambda {|x| x.customer_id.present?}



  def initialize(property=nil)
    @property = property ? property : Property.new
    @customer = Customer.new
    @customer_property = CustomerProperty.new
  end

  def property
    @property ||= Property.new
  end

  def customer
    @customer ||= Customer.new
  end

  def customer_property
    @customer_property ||= CustomerProperty.new
  end

  def submit(params)
    property.attributes  = params.slice(:street_address_1,:street_address_2,:city,:state_id,:postal_code)
    customer.attributes  = params.slice(:first_name,:middle_initial,:last_name, :primary_phone, :secondary_phone)
    using_existing       = use_existing_customer?(params)
    property_owner       = using_existing ? Customer.find(params[:customer_id]) : customer
    customer_property.attributes = {customer:property_owner, property:property}
    if self.valid?
      property.save!
      unless using_existing
        customer.save!
      end
      customer_property.save!
      true
    else
      false
    end
  end

  private

  def unique_street_address
    p = Property.where(street_address_1: property.street_address_1, city: property.city, state_id: property.state_id)
    unless p.empty?
      errors.add(:street_address_1, "is already taken for this city and state")
    end
  end

  def use_existing_customer?(params)
    params[:customer_id].present?
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Property')
  end

end