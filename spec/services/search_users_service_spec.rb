# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchUsersService, type: :service do
  include ActiveJob::TestHelper

  context 'when has valid query params and search by name' do
    before do
      create(:user, name: 'Flavio A', email: 'flavio@provedor.com')
      create(:user, name: 'Gutenberg ', email: 'gutenberg@provedor.com')
    end

    let(:query_params) { { search: 'Flavio', order: 'asc' } }

    subject { SearchUsersService.new(query_params).call }

    it 'return list with the exactly user name' do
      expect(subject.size).to eq 1
      expect(subject.first.name).to eq 'Flavio A'
    end
  end

  context 'when has valid query params and search by email' do
    before do
      create(:user, name: 'Flavio A', email: 'flavio@provedor.com')
      create(:user, name: 'Gutenberg ', email: 'gutenberg@provedor.com')
    end

    let(:query_params) { { search: 'flavio@provedor.com', order: 'asc' } }

    subject { SearchUsersService.new(query_params).call }

    it 'return list with the exactly user name' do
      expect(subject.size).to eq 1
      expect(subject.first.email).to eq 'flavio@provedor.com'
    end
  end
end
