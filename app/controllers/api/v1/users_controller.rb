# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      before_action :authorized, except: %i[login]
      load_and_authorize_resource class: 'User', except: %i[login]

      # before_action :authenticate_user!
      # GET /users
      def index
        @users = User.all
      end

      # Authentication actions

      # REGISTER
      def create
        @user = User.create(user_params)

        if @user.valid?
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token }
        else
          render json: { error: 'Invalid email or password' }
        end
      end

      # DELETE /users/1 or /users/1.json
      def destroy
        @user.destroy
        render json: { message: 'Delete user success' }
      end

      # LOGGING IN
      def login
        @user = User.find_by(email: params[:email])

        if @user
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token }
        else
          render json: { error: 'Invalid email or password' }
        end
      end

      def auto_login
        render json: @user
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation, :role_id)
      end
    end
  end
end
