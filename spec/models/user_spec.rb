# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    role_admin = create(:role, name: 'Admin')
    role_regular = create(:role, name: 'Regular')

    create(:user, name: 'Alberto', email: 'alberto@provedor.com', role: role_admin)
    create(:user, name: 'Zileide', email: 'zileide@provedor.com', role: role_regular)
    create(:user, name: 'Joana', email: 'joana@provedor.com', role: role_regular)
  end

  describe '.search_by' do
    context 'when search is by name' do
      subject { User.search_by({ name: 'Joana' }) }

      it 'returns the user by the name' do
        expect(subject.size).to eq 1
        expect(subject.first.name).to eq 'Joana'
      end
    end

    context 'when search is by email' do
      subject { User.search_by({ email: 'joana@provedor.com' }) }

      it 'returns the user by the email' do
        expect(subject.size).to eq 1
        expect(subject.first.email).to eq 'joana@provedor.com'
      end
    end

    context 'when search is by role' do
      subject { User.search_by({ role_name: 'Admin' }) }

      it 'returns the user by the role' do
        expect(subject.size).to eq 1
        expect(subject.first.role.name).to eq 'Admin'
      end
    end

    context 'when search query is nil' do
      subject { User.search_by(nil) }

      it 'returns the user by the role' do
        expect(subject.size).to eq 3
      end
    end
  end
end
