# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET api/v1/users' do
    context 'when headers has a valid token' do
      let(:user) { create(:user, name: "João") }
      let(:valid_token) { JWT.encode({ user_id: user.id }, 's3cr3t') }

      context 'when has not query params' do
        it 'returns a successful response' do
          get api_v1_users_url, headers: { authorization: "token #{valid_token}" }, as: :json
          json_response = JSON.parse(response.body)

          expect(response).to be_successful
          expect(json_response.size).to eq 1
          expect(json_response.first['name']).to eq(user[:name])
          expect(json_response.first['email']).to eq(user[:email])
          expect(json_response.first['role']).to eq(user.role.name)
        end
      end

      context 'when has query params' do
        it 'returns a successful response' do
          params = { query: {name: "João"} }
          get api_v1_users_url, params: params, headers: { authorization: "token #{valid_token}" }, as: :json
          json_response = JSON.parse(response.body)
          
          expect(response).to be_successful
          expect(json_response.size).to eq 1
          expect(json_response.first['name']).to eq(user[:name])
        end
      end
    end

    context 'when headers has a invalid token' do
      let(:invalid_token) { 'xpto' }

      it 'returns a unsucessful status code (401 - unauthorized)' do
        get api_v1_users_url, headers: { authorization: invalid_token }, as: :json
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST api/v1/users' do
    let(:role) { create(:role, name: 'Admin') }
    let(:user) { create(:user, role: role) }

    context 'when headers has a valid token' do
      let(:valid_token_admin) { JWT.encode({ user_id: user.id }, 's3cr3t') }
      let(:valid_attributes) do
        { name: 'User', email: 'user@provedor.com', password: '123456', password_confirmation: '123456',
          role_id: user.role.id }
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
          post api_v1_users_url, params: valid_attributes, headers: { authorization: "token #{valid_token_regular}" }
          expect(response.status).to eq 403
        end
      end
    end

    context 'when headers has a invalid token' do
      let(:invalid_token) { 'xpto' }
      let(:valid_attributes) do
        { name: 'User', email: 'user@provedor.com', password: '123456', password_confirmation: '123456',
          role_id: user.role.id }
      end

      it 'returns a unsucessful status code (401 - unauthorized)' do
        post api_v1_users_url, params: valid_attributes, headers: { authorization: invalid_token }
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE api/v1/users/:id' do
    let(:role) { create(:role, name: 'Admin') }
    let(:user) { create(:user, role: role) }
    let(:token) { JWT.encode({ user_id: user.id }, 's3cr3t') }
    let(:user_to_be_deleted) { create(:user, role: role, email: 'another@provedor.com') }

    context 'when headers has a valid token' do
      before do
        user
        user_to_be_deleted
      end

      context 'when the token is of a user admin' do
        it 'returns a successful response' do
          delete api_v1_user_url(user_to_be_deleted), headers: { authorization: "token #{token}" }
          expect(response).to be_successful
        end

        it 'delete the user of the database' do
          expect do
            delete api_v1_user_url(user_to_be_deleted),
                   headers: { authorization: "token #{token}" }
          end.to change(User, :count).by(-1)
        end
      end

      context 'when the token is NOT of a user admin' do
        let(:role) { create(:role, name: 'Regular') }

        it 'returns a unsucessful status code (403 - forbidden)' do
          delete api_v1_user_url(user_to_be_deleted), headers: { authorization: "token #{token}" }
          expect(response.status).to eq 403
        end

        it 'do not delete the user of the database' do
          expect do
            delete api_v1_user_url(user_to_be_deleted),
                   headers: { authorization: "token #{token}" }
          end.to change(User, :count).by(0)
        end
      end
    end

    context 'when headers has not a valid token' do
      before do
        user
        user_to_be_deleted
      end

      context 'when the token is NOT of a user admin' do
        it 'returns a unsucessful status code (401 - unauthorized)' do
          delete api_v1_user_url(user), headers: {}
          expect(response.status).to eq 401
        end

        it 'do not delete the user of the database' do
          expect { delete api_v1_user_url(user), headers: {} }.to change(User, :count).by(0)
        end
      end
    end
  end
end
