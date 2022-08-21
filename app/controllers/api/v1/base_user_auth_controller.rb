# frozen_string_literal: true

module Api
  module V1
    # Base methods context API
    class BaseUserAuthController < ActionController::API
      rescue_from CanCan::AccessDenied do |_exception|
        render json: { message: 'Access denied' }, status: 403
      end

      def encode_token(payload)
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
      end

      def auth_header
        request.headers['Authorization']
      end

      def decoded_token
        return unless auth_header

        token = auth_header.split[1]
        begin
          JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end

      def logged_in_user
        return unless decoded_token

        user_id = decoded_token[0]['user_id']
        @user = User.find_by(id: user_id)
      end

      def logged_in?
        !!logged_in_user
      end

      def authorized
        render json: { message: 'No authorized!' }, status: :unauthorized unless logged_in?
      end

      def current_user
        @current_user ||= User.find(decoded_token.first['user_id']) if decoded_token
      end
    end
  end
end
