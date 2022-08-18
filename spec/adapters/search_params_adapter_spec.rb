# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchParamsAdapter, type: :service do
  context 'when has a search value name' do
    let(:search) do
      { search: 'Flavio' }
    end

    subject { SearchParamsAdapter.new(search).call }

    it 'return the expected key(name)' do
      expected_params = { name: 'Flavio' }
      expect(subject).to eq expected_params
    end
  end

  context 'when has a search value email' do
    let(:search) do
      { search: 'flavio@provedor.com' }
    end

    subject { SearchParamsAdapter.new(search).call }

    it 'return the expected key(email)' do
      expected_params = { email: 'flavio@provedor.com' }
      expect(subject).to eq expected_params
    end
  end
end
