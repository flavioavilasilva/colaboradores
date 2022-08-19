# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/roles', type: :request do
  describe 'DELETE /user/:id' do
    let(:user_admin_to_login) { create(:user, name: 'Adailton', email: 'adailton@provedor.com') }
    let(:user_to_delete) { create(:user, name: 'Zileide', email: 'zileide@provedor.com') }

    context 'with a valid login' do
      before do
        user_admin_to_login
      end

      it 'redirects to users' do
        sign_in(user_admin_to_login)

        delete "/users/#{user_to_delete.id}"
        expect(response.body).to include('www.example.com/users')
      end
    end

    context 'without a valid login' do
      it 'redirects to users sign in' do
        delete "/users/#{user_to_delete.id}"
        expect(response.body).to include('www.example.com/users/sign_in')
      end
    end
  end
end
