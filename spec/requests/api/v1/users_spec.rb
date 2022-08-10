# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:role_regular) { Role.create!({ name: 'Regular', description: 'Can read items' }) }

  before do
    User.create!(valid_attributes)
  end

  let(:valid_attributes) do
    { name: 'Admin', email: 'admin@admin.com', password: 'admin1', password_confirmation: 'admin1',
      role_id: role_regular.id }
  end

  let(:invalid_attributes) do
    {}
  end

  let(:valid_headers) do
    {}
  end

  describe 'GET api/v1/users' do
    it 'renders a successful response' do
      get api_v1_users_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it 'returns the valids attributes' do
      get api_v1_users_url, headers: valid_headers, as: :json
      json_response = JSON.parse(response.body).first

      expect(json_response['name']).to eq(valid_attributes[:name])
      expect(json_response['email']).to eq(valid_attributes[:email])
      expect(json_response['role_id']).to eq(valid_attributes[:role_id])
    end
  end
end
