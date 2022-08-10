# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/edit', type: :view do
  context 'when user is admin' do
    before(:each) do
      role_admin = Role.create!(name: 'Admin User', description: 'Can perform any CRUD operation on any resource')
      user_admin = User.create!({ name: 'Admin', email: 'admin@admin.com', password: 'admin1',
                                  password_confirmation: 'admin1', role_id: role_admin.id })

      @user = assign(:user, user_admin)
    end

    it 'renders the edit user form' do
      render

      assert_select 'form[action=?][method=?]', user_path(@user), 'post' do
        assert_select 'input[name=?]', 'user[name]'

        assert_select 'input[name=?]', 'user[role_id]'
      end
    end
  end

  context 'when user is NOT admin' do
    before(:each) do
      role_regular = Role.create!(name: 'Regular', description: 'Can read informations')

      user_regular = User.create!({ name: 'Regular User', email: 'regular_user@provedor.com', password: '123456',
                                    password_confirmation: '123456', role_id: role_regular.id })
      @another_regular_user = User.create!({ name: 'Another Regular User', email: 'another_regular_user@provedor.com',
                                             password: '123456', password_confirmation: '123456', role_id: role_regular.id })

      assign(:user, user_regular)
    end

    it 'not renders the edit user form' do
      render

      assert_select 'form[action=?][method=?]', user_path(@another_regular_user), 'post', false
    end
  end
end
