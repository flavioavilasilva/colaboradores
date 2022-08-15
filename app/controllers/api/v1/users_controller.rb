# frozen_string_literal: true

module Api
  module V1
    # User API actions
    class UsersController < Api::V1::BaseUserAuthController
      before_action :authorized, except: %i[login]
      load_and_authorize_resource class: 'User', except: %i[login]

      # GET api/v1/users?query[name]=xpto
      def index
        @users = User.search_by(query)
      end

      # POST api/v1/users
      def create
        @user = CreateUserService.new(user_params).call

        if @user.errors.blank?
          token = encode_token({ user_id: @user.id })
          render json: { user: @user, token: token }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :bad_request
        end
      end

      # DELETE api/v1/user/:id
      def destroy
        @user = User.find(params[:id])
        @user.destroy
        render json: { message: 'Delete user success' }
      end

      # POST api/v1/login
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

      def query
        return if params[:query].nil?

        params.require(:query).permit(:name, :email, :role_name)
      end

      def user_params
        params.permit(
          :email,
          :password,
          :password_confirmation,
          :name,
          :role_id
        )
      end
    end
  end
end
