# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET api/v1/users/get-token' do
    context 'when has a valid user application' do
      let(:user) { create(:user) }
      before { user }

      it 'returns a valid token' do
        post api_v1_token_url, params: { email: user.email, password: user.password }

        json_response = JSON.parse(response.body)
        expect(json_response['token']).not_to be_nil
      end
    end
  end
end
