class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
	  params.require(:user).permit(:user_name, :team_name, :email, :password, :password_confirmation, :team_owner)
  end

  def account_update_params
	  params.require(:user).permit(:user_name, :team_name, :email, :password, :password_confirmation, :current_password, :team_owner)
  end
end
