class AdministrativeController < ApplicationController
  def index
  end

  def login_requests
    render template: 'administrative/login_requests'
  end

  def system_users
    render template: 'administrative/system_users'
  end

  def confirm_user
    respond_to do |format|
      format.js {
        user = User.find params[:user_id]
        user.admin_confirm(current_user)
        render json:{message:"#{user.email} is now allowed to login"}, status: :ok
      }
    end
  end

  def revoke_login
    respond_to do |format|
      format.js {
        user = User.find params[:user_id]
        user.revoke_login(current_user)
        render json:{message:"#{user.email} login privileges have been revoked."}, status: :ok
      }
    end
  end

  def deny_user
    respond_to do |format|
      format.js {
        user = User.find params[:user_id]
        user.deny_login(current_user)
        render json:{message:"#{user.email} has been removed from the system."}, status: :ok
      }
    end
  end

  def data_tables_source_unconfirmed
    @users = User.unconfirmed
    respond_to do |format|
      format.js {render json: {aaData:@users.map(&:to_data_table_row_unconfirmed)}}
    end
  end

  def data_tables_source_confirmed
    @users = User.confirmed
    respond_to do |format|
      format.js {render json: {aaData:@users.map(&:to_data_table_row_confirmed)}}
    end
  end

end
