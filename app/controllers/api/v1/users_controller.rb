# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      # GET /users
      def index
        @users = User.all
      end
    end
  end
end
