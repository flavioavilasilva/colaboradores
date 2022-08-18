# frozen_string_literal: true

# User actions
class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  load_and_authorize_resource

  def index
    @users = SearchUsersService.new(query_params).call
  end

  private

  def query_params
    params.permit(:search, :user)
  end
end
