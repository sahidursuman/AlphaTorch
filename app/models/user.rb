class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def admin_confirmed?
    self.admin_confirmed
  end

  def admin_confirm(requesting_user=current_user)
    if requesting_user.admin_confirmed?
      self.admin_confirmed = true
      save!
    end
  end

end
