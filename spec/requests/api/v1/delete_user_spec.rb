# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
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
