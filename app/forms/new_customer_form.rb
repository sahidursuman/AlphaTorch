class NewCustomerForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  delegate :street_address_1,:street_address_2,:city,:state_id,:postal_code, to: :property
  delegate :status_code, :description, :first_name,:middle_initial,:last_name,:primary_phone,:secondary_phone,:email, to: :customer

  #validates_presence_of :street_address_1, :city, :state_id, :postal_code
  validates_presence_of :first_name, :last_name

  def initialize(options={})
    @customer = options[:customer] ? options.delete(:customer) : Customer.new
    @property = Property.new
    @customer_property = CustomerProperty.new
  end

  def customer
    @customer ||= Customer.new
  end

  def property
    @property ||= Property.new
  end

  def customer_property
    @customer_property ||= CustomerProperty.new
  end

  def submit(params)
    customer.attributes          = params.slice(:first_name,:middle_initial,:last_name, :primary_phone, :secondary_phone, :email)
    property.attributes          = params.slice(:street_address_1,:street_address_2,:city,:state_id,:postal_code)
    using_existing               = use_existing_property?(params)
    customer_property_owner      = using_existing ? Property.find(params[:property_id]) : property
    customer_property.attributes = {customer:customer, property:customer_property_owner, owner: true}
    if unique_email
      p 'UNIQUE EMAIL'
      if self.valid?
        if property_data_present?(params)
          p 'PROPERTY DATA PRESENT'
          if property_valid?(params)
            p 'PROPERTY VALID'
            if property_exists?(params)
              if property.current_customer_property
                 p 'PROPERTY EXISTS AND IS OWNED RETURNING FALSE'
                 self.errors.add(:property, 'Exists And Is Already Owned')
                 return false
              end
              p 'PROPERTY EXISTS BUT IS NOT OWNED RETURNING TRUE'
              p 'FORM VALID - SAVING CUSTOMER'
              customer.save
              customer_property.save
              return true
            else
              p 'PROPERTY DOES NOT EXIST AND IS NOW BEING SAVED RETURNING TRUE'
              p 'FORM VALID - SAVING CUSTOMER'
              customer.save
              property.save
              customer_property.save
              return true
            end
          else
            p 'PROPERTY IS NOT VALID RETURNING FALSE'
            self.errors.add(:property, 'Information Is Not Valid')
            return false
          end
        else
          p 'NO PROPERTY DATA PRESENTED'
          p 'CREATING CUSTOMER'
          customer.save
          return true
        end
      else
        p 'FORM IS NOT VALID RETURNING FALSE'
        return false
      end
    else
      p 'NOT A UNIQUE EMAIL RETURNING FALSE'
      return false
    end
  end

  def update_attributes(params)
    customer.attributes  = params.slice(:status_code,:description,:first_name,:middle_initial,:last_name,:primary_phone,:secondary_phone,:email)
    if customer.changed?
      p 'CUSTOMER HAS CHANGED'
      if self.valid? && unique_email
        customer.save rescue(errors.add(:email, 'is already used.  Please enter a unique email address.'); return false;)
        p 'CUSTOMER CHANGED IS TRUE AND SAVING'
        return true
      else
        p 'CUSTOMER CHANGED IS FALSE'
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
  end

  def property_nil
    if property.nil?

    end
  end

  private

  def use_existing_property?(params)
    p 'CHECKING IF USING EXISTING PROPERTY'
    params[:property_id].present?
  end

  def property_data_present?(params)
    p 'CHECKING PROPERTY DATA PRESENT'
    [street_address_1, street_address_2, city, postal_code].map(&:blank?).include?(false) || use_existing_property?(params)
  end

  def property_valid?(params)
    p 'CHECKING PROPERTY VALID'
    if use_existing_property?(params)
      return true
    else
      ![street_address_1, city, state_id, postal_code].map(&:blank?).include?(true)
    end
  end

  def property_exists?(params)
    if use_existing_property?(params)
      @property = Property.find(params[:property_id])
      return true
    else
      Property.where({street_address_1:street_address_1, city:city, state_id:state_id, postal_code:postal_code}).count > 0
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Customer')
  end

  def unique_email
    if Customer.where("email = '#{customer.email}'#{' AND id = ' + customer.id.to_s unless customer.id.nil?}").exists?
    #if self.customer.exists?(email: customer.email)
      errors.add(:email, 'Is Already Taken!')
      return false
    else
      return true
    end
  end


end