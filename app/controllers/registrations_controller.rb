# frozen_string_literal: true

# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def create
    @user = CreateUserService.new(user_params).call
    redirect_to authenticated_root_url
  end

  private

  def user_params
    params[:user][:password] = '123456'
    params[:user][:password_confirmation] = '123456'

    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      :role_id
    )
  end
end
