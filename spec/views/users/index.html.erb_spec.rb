# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  let(:role_admin) { Role.create!(name: 'Admin User', description: 'Can perform any CRUD operation on any resource') }
  let(:user_admin) do
    User.create!({ name: 'Admin', email: 'admin@admin.com', password: 'admin1',
                   password_confirmation: 'admin1', role_id: role_admin.id })
  end

  before(:each) do
    user_admin
    another_user = User.create!({ name: 'Another_user', email: 'another_user@another_user.com',
                                  password: 'another_user', password_confirmation: 'another_user',
                                  role_id: role_admin.id })

    assign(:users, [user_admin, another_user])
  end

  it 'renders a list of users' do
    sign_in(user_admin)
    render
    assert_select 'div#name', 2
    assert_select 'div#email', 2
    assert_select 'div#role_id', 2
  end
end
