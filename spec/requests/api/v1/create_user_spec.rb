# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST api/v1/users' do
    let(:role) { create(:role, name: 'Admin') }
    let(:user) { create(:user, role: role) }

    context 'when headers has a valid token' do
      let(:valid_token_admin) { JWT.encode({ user_id: user.id }, 's3cr3t') }
      let(:valid_attributes) do
        { name: 'User', email: 'user@provedor.com', password: '123456', password_confirmation: '123456',
          role_id: role.id }
      end

      context 'when the token is of a user admin' do
        it 'returns a successful response' do
          post api_v1_users_url, params: valid_attributes, headers: { authorization: "token #{valid_token_admin}" }
          expect(response).to be_successful
        end

        it 'sends welcome e-mail user' do
          expect { UserMailer.welcome_email.deliver_later }.to(have_enqueued_job.on_queue('default'))
          post api_v1_users_url, params: valid_attributes, headers: { authorization: "token #{valid_token_admin}" }
        end
      end

      context 'when the token is of a regular user' do
        let(:role) { create(:role, name: 'Regular') }
        let(:user) { create(:user, role: role) }
        let(:valid_token_regular) { JWT.encode({ user_id: user.id }, 's3cr3t') }

        it 'returns a unsucessful status code (403 - forbidden)' do
          post api_v1_users_url, params: valid_attributes,
                                 headers: { authorization: "token #{valid_token_regular}" }
          expect(response.status).to eq 403
        end
      end
    end

    context 'when headers has a invalid token' do
      let(:invalid_token) { 'xpto' }
      let(:valid_attributes) do
        { name: 'User', email: 'user@provedor.com', password: '123456', password_confirmation: '123456',
          role_id: role.id }
      end

      it 'returns a unsucessful status code (401 - unauthorized)' do
        post api_v1_users_url, params: valid_attributes, headers: { authorization: invalid_token }
        expect(response.status).to eq 401
      end
    end
  end
end
