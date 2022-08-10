# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before(:each) do
    role_admin = Role.create!(name: 'Admin User', description: 'Can perform any CRUD operation on any resource')

    user_admin = User.create!({ name: 'Admin', email: 'admin@admin.com', password: 'admin1',
                                password_confirmation: 'admin1', role_id: role_admin.id })
    another_user = User.create!({ name: 'Another_user', email: 'another_user@another_user.com',
                                  password: 'another_user', password_confirmation: 'another_user', role_id: role_admin.id })

    assign(:users, [user_admin, another_user])
  end

  it 'renders a list of users' do
    render
    assert_select 'div#users' do |elements|
      elements.each do |element|
        assert_select element, 'div#user_1', 1
        assert_select element, 'div#user_2', 1
      end
    end
  end
end
