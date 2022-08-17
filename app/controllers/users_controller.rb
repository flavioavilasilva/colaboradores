# frozen_string_literal: true

# User actions
class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  load_and_authorize_resource

  def index
    @users = User.all
  end
end
