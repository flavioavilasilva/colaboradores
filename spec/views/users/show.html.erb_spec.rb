# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    role = Role.create!({ name: 'Admin', description: 'xpto' })
    user = User.create!({ name: 'Teste', email: 'xpto@xpto.com', password: '123456', password_confirmation: '123456',
                          role_id: role.id })
    @user = assign(:user, user)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
