# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      rescue_from CanCan::AccessDenied do |_exception|
        render json: { message: 'Access denied' }, status: 403
      end

      def encode_token(payload)
        JWT.encode(payload, 's3cr3t')
      end

      def auth_header
        # { Authorization: 'Bearer <token>' }
        request.headers['Authorization']
      end

      def decoded_token
        if auth_header
          token = auth_header.split[1]
          # header: { 'Authorization': 'Bearer <token>' }
          begin
            JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
          rescue JWT::DecodeError
            nil
          end
        end
      end

      def logged_in_user
        if decoded_token
          user_id = decoded_token[0]['user_id']
          @user = User.find_by(id: user_id)
        end
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
