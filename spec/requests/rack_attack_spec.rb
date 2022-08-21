# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rack::Attack' do
  context 'when somebody try make more then 10 request by minute' do
    let(:user) { create(:user, name: 'João') }
    let(:valid_token) { JWT.encode({ user_id: user.id }, 's3cr3t') }

    before do
      Rack::Attack.enabled = true
      get users_url

      10.times { get api_v1_users_url, headers: { authorization: "token #{valid_token}" }, as: :json }
    end

    it 'return message saying Retry later' do
      get api_v1_users_url, headers: { authorization: "token #{valid_token}" }, as: :json

      expect(response.body).to include('Retry later')
    end

    after do
      Rack::Attack.enabled = false
      Rack::Attack.reset!
    end
  end
end
