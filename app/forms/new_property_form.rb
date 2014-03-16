class NewPropertyForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  delegate :street_address_1,:street_address_2,:city,:state_id,:postal_code, to: :property
  delegate :first_name,:middle_initial,:last_name,:primary_phone,:secondary_phone,:email, to: :customer

  attr :customer_id,:new_first_name,:new_middle_initial,:new_last_name,:new_primary_phone,:new_secondary_phone

  validates_presence_of :street_address_1, :city, :state_id, :postal_code
  #validate  :unique_street_address
  validates_presence_of :first_name, :last_name, unless: lambda { |x|
    x.customer_id.present? || x.customer_property.customer_id.present?
  }



  def initialize(options={})
    @property = options[:property] ? options.delete(:property) : Property.new
    @customer_property = options[:customer_property] ? options.delete(:customer_property) : CustomerProperty.new
    @customer = options[:customer] ? options.delete(:customer) : Customer.new
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
    customer.attributes  = params.slice(:first_name,:middle_initial,:last_name, :primary_phone, :secondary_phone, :email)
    using_existing       = use_existing_customer?(params)
    property_owner       = using_existing ? Customer.find(params[:customer_id]) : customer
    customer_property.attributes = {customer:property_owner, property:property, owner: true}
    if self.valid?#uniqueness validation moved to database.
      property.save! rescue(errors.add(:property, 'already exists!'); return false;)#database error thrown if duplicate address added.
      unless using_existing
        customer.save!
      end
      customer_property.save!
      true
    else
      false
    end
  end

  def update_attributes(params)
    property.attributes  = params.slice(:street_address_1,:street_address_2,:city,:state_id,:postal_code)
    if !customer_change?(params)
      if property.changed?

        if self.valid?
          property.save rescue(errors.add(:property, 'already exists!'); return false;)#database error thrown if duplicate address added.
          p 'CUSTOMER NOT AND PROPERTY CHANGED RETURNING TRUE'
          return true
        else
          p 'CUSTOMER NOT AND PROPERTY CHANGED RETURNING FALSE'
          return false
        end

      else

        if self.valid?
          p 'NO CHANGE RETURNING TRUE'
          return true
        else
          p 'NO CHANGE RETURNING FALSE'
          return false
        end

      end
    else#customer has changed
      if property.changed? && self.valid?
        property.save rescue(errors.add(:property, 'already exists!'); return false;)#database error thrown if duplicate address added.
        p 'CUSTOMER AND PROPERTY CHANGED AND ALL VALID'
        return true
      else
        p 'CUSTOMER HAS CHANGED BUT PROPERTY DID NOT'
        unless set_new_property_owner(params)
          p 'SET NEW PROPERTY RETURNING FALSE'
          return false
        end
      end
      p 'GOT TO END RETURNING TRUE'
      return true
    end
  end

  private

  #def unique_street_address
  #  p = Property.where(street_address_1: property.street_address_1, city: property.city, state_id: property.state_id)
  #  unless p.empty?
  #    errors.add(:street_address_1, "is already taken for this city and state")
  #  end
  #end

  def use_existing_customer?(params)
    params[:customer_id].present?
  end

  def customer_change?(params)
    new_customer = params.slice(:new_first_name,:new_middle_initial,:new_last_name,:new_primary_phone,:new_secondary_phone)
    (new_customer.values.map(&:present?).include?(true) || (use_existing_customer?(params) && customer.id != params[:customer_id]))
  end

  def set_new_property_owner(params)

    #check if there are workorders for the property. do not allow if there are active workorders.
    if @property.has_active_workorders?
      p 'PROPERTY HAS ACTIVE INVOICES'
      errors.add(:property, 'Has Active Workorders. These <u>MUST</u> Be Cancelled Before Changing Ownership.'.html_safe)
      return false
    end

    @customer = use_existing_customer?(params) ? Customer.find(params[:customer_id]) : Customer.new

    if customer.new_record?
      customer_property.owner = false
      customer_property.save
      customer.first_name = params[:new_first_name]
      customer.middle_initial = params[:new_middle_initial]
      customer.last_name = params[:new_last_name]
      customer.primary_phone = params[:new_primary_phone]
      customer.secondary_phone = params[:new_secondary_phone]
      if customer.valid?
        customer.save
      else
        return false
      end
      @customer_property = CustomerProperty.create(property:property, customer:customer, owner:true)
    else #customer already exists
      #check if the customer has owned this property in the past
      p 'customer already exists'
      cp = CustomerProperty.where(customer_id:customer.id, property_id:property.id).first_or_initialize
      if cp
        #make sure some smart ass is not trying to change to the current owner
        if !cp.owner
          customer_property.owner = false
          customer_property.save
          cp.owner = true
          cp.save
        else
          p 'customer already owns this'
          errors.add(:customer, 'Already Owns This Property')
          return false
        end
      else
        cp.owner = true
        cp.save
        return true
      end
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Property')
  end

end