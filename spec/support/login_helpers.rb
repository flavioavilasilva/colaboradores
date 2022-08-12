# frozen_string_literal: true

module LoginHelpers
  def create_user_and_headers
    before { user }
    let(:user) { User.create!(valid_attributes) }
    let(:valid_attributes) do
      { name: 'User', email: 'user@provedor.com', password: '123456', password_confirmation: '123456',
        role_id: role.id }
    end
    let(:role) { Role.create!({ name: 'Regular', description: 'Can read items' }) }
    let(:valid_headers) do
      { authorization: "token #{JWT.encode({ user_id: user.id }, 's3cr3t')}" }
    end
  end
end
