class User < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin_confirmed
  # attr_accessible :title, :body

  scope :unconfirmed, -> {where(admin_confirmed:false)}
  scope :confirmed, -> {where(admin_confirmed:true)}

  def admin_confirmed?
    self.admin_confirmed
  end

  def admin_confirm(requesting_user=current_user)
    if requesting_user.admin_confirmed?
      self.admin_confirmed = true
      self.confirmed_at = DateTime.now
      save!
    end
  end

  def deny_login(requesting_user=current_user)
    if requesting_user.admin_confirmed?
      self.destroy
    end
  end

  def revoke_login(requesting_user=current_user)
    if requesting_user.admin_confirmed?
      self.admin_confirmed = false
      save!
    end
  end


  def to_data_table_row_unconfirmed
    [mail_to(self.email), self.confirmed_at.strftime('%Y-%m-%d'), approve_link, deny_link]
  end

  def approve_link
    link_to 'Approve',
    Rails.application.routes.url_helpers.approve_login_request_path(user_id:self.id),
    remote:true,
    id:'approve_login_link',
    method: :post,
    data:{:confirm => "APPROVE #{self.email}?"}
  end

  def deny_link
    link_to 'Deny',
    Rails.application.routes.url_helpers.deny_login_request_path(user_id:self.id),
    remote:true,
    method: :delete,
    id:'deny_login_link',
    data:{:confirm => "DENY #{self.email}?"}
  end

  def to_data_table_row_confirmed
    [mail_to(self.email), self.confirmed_at.strftime('%Y-%m-%d'), revoke_link, destroy_link]
  end

  def revoke_link
    link_to 'Revoke',
            Rails.application.routes.url_helpers.revoke_login_path(user_id:self.id),
            remote:true,
            id:'revoke_login_link',
            method: :post,
            data:{:confirm => "REVOKE ACCESS FOR #{self.email}?"}
  end

  def destroy_link
    link_to 'Delete',
            Rails.application.routes.url_helpers.destroy_user_path(user_id:self.id),
            remote:true,
            method: :delete,
            id:'destroy_user_link',
            data:{:confirm => "DELETE #{self.email}?"}
  end

end
