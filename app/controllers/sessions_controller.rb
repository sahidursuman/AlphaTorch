class SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate!(auth_options)

    if self.resource.admin_confirmed?
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      set_flash_message(:alert, :not_confirmed) if is_navigational_format?
      sign_out(resource)
      redirect_to new_session_path(resource)
    end

  end

end