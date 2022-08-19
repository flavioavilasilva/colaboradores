# frozen_string_literal: true

# User actions
class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index destroy]
  load_and_authorize_resource

  def index
    cache_key_with_version = "users/index/#{query_params}"
    @users = Rails.cache.fetch(cache_key_with_version, expires_in: 5.minutes) do
      SearchUsersService.new(query_params).call
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

  def query_params
    params.permit(:search, :user)
  end
end
