# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchUsersService, type: :service do
  include ActiveJob::TestHelper

  context 'when has valid query params' do
    before do
      create(:user, name: 'Flavio', email: 'flavio@provedor.com')
      create(:user, name: 'Gutenberg', email: 'gutenberg@provedor.com')
    end

    let(:query_params) { { search: 'Flavio', order: 'asc' } }

    subject { SearchUsersService.new(query_params).call }

    it 'return list with the exactly user name' do
      expect(subject.size).to eq 1
      expect(subject.first.name).to eq 'Flavio'
    end
  end
end
