class Landscaper < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  require 'model_locking'
  include ModelLocking

  belongs_to :status, primary_key: 'status_code', foreign_key: 'status_code'

  validates_presence_of :first_name, :last_name, :primary_phone
  validate :unique_email, :unique_primary_phone

  scope :active,    ->{where(status_code: Status.get_code('Active'))}
  scope :inactive,  ->{where(status_code: Status.get_code('Inactive'))}
  scope :locked,    ->{where(status_code: Status.get_code('Locked'))}

  def to_data_table_row
    [name, first_phone, email_address, status.status, rate, edit_link, destroy_link]
  end

  def name
    mi = (self.middle_initial.nil? || self.middle_initial.empty?) ? '' : self.middle_initial + '. '
    self.first_name + ' ' + mi + self.last_name
  end

  def html_name
    link_to name.html_safe, Rails.application.routes.url_helpers.landscaper_path(self)
  end

  def first_phone
    self.primary_phone
  end

  def rate
    <<-HTML
    <input class='rating' data-size='xs' data-readonly='true' data-show-clear="false" data-show-caption='false' value="#{self.rating}"/>
    HTML
  end

  def email_address
    self.email.blank? ? 'No email' : mail_to(self.email)
  end

  def unique_email
    unless self.email.blank?
      if (Landscaper.where(:email => self.email).exists?) && (self.email != self.email_was)
        errors.add(:email, 'is already taken.  Please enter a unique email address')
        return false
      else
        return true
      end
    end
    p 'EMAIL IS NIL OR EMPTY, RETURNING TRUE'
    return true
  end

  def unique_primary_phone
    if (Landscaper.where(:primary_phone => self.primary_phone).exists?) && (self.primary_phone != self.primary_phone_was)
      errors.add(:primary_phone, 'number is taken. Please enter a unique phone number')
      return false
    else
      return true
    end
  end

  def edit_link
    link_to 'Edit',
    Rails.application.routes.url_helpers.edit_landscaper_path(self),
    remote:true,
    id:'edit_landscaper_link'
  end

  def destroy_link
    link_to 'Destroy',
    Rails.application.routes.url_helpers.landscaper_path(self),
    remote:true,
    method: :delete,
    id:'destroy_landscaper_link',
    data:{confirm:'Are you sure?'}
  end

  #def change_landscaper_status_link
  #  change_status_link(Landscaper, @landscaper.id, %w(Active Locked), @landscaper.status.status)
  #end

  def change_status(status)
    case status
      when 'Active'
        remove_hold
      when 'Locked'
        set_on_hold
    end
  end

  def set_on_hold
    unless status_code == Status.get_code('Locked')
      self.status_code = Status.get_code('Locked')
      self.save
    end
  end

  def remove_hold
    unless status_code == Status.get_code('Active')
      self.status_code = Status.get_code('Active')
      self.save
    end
  end

end
