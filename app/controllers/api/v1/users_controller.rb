# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      after_action :send_email_assync, only: %i[create]
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
        permitted_params = user_params
        @user = User.new(permitted_params)
        byebug
        if @user.save
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token }
        else
          render json: { error: 'Invalid email or password' }
        end
      end

      # DELETE /users/1 or /users/1.json
      def destroy
        @user = User.find(params[:id])
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
        params.permit(
          :email,
          :password,
          :password_confirmation,
          :name,
          :role_id
        )
      end

      def send_email_assync
        return if @user.id.blank?

        UserMailer.with(user: @user).welcome_email.deliver_later
      end
    end
  end
end
