# frozen_string_literal: true

# User actions
class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index destroy create]
  load_and_authorize_resource

  def index
    cache_key_with_version = "users/index/#{query_params}"
    @users = Rails.cache.fetch(cache_key_with_version, expires_in: 5.minutes) do
      SearchUsersService.new(query_params).call
    end
  end

  def create
    @user = CreateUserService.new(user_params).call

    respond_to do |format|
      if @user.errors.blank?
        format.html { redirect_to users_url, notice: 'Usuário criado com sucesso!' }
      else
        format.html { redirect_to new_user_url, notice: @user.errors.to_s }
      end
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Usuário excluido com sucesso!' }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role_id)
  end

  def query_params
    params.permit(:search, :user)
  end
end
