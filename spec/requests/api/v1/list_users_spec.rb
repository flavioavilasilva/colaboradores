# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET api/v1/users' do
    context 'when headers has a valid token' do
      let(:user) { create(:user, name: 'João Pedro') }
      let(:valid_token) { JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base) }

      context 'when has not search params' do
        before do
          expect_any_instance_of(SearchUsersService).to receive(:call).and_return([user])
        end

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

      context 'when has search params' do
        before do
          expect_any_instance_of(SearchUsersService).to receive(:call).and_return([user])
        end

        it 'returns a successful response' do
          params = { search: 'João' }
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
end
