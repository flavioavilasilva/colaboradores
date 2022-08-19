# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/user', type: :request do
  describe 'POST /create' do
    let(:role_id) { create(:role).id }
    let(:user_admin_to_login) { create(:user, name: 'Adailton', email: 'adailton@provedor.com') }
    let(:valid_attributes) do
      { name: 'Flavio', email: 'flavio@provedor.com', password: '123456', password_confirmation: '123456',
        role_id: role_id }
    end

    context 'with a valid login' do
      before do
        user_admin_to_login
      end

      context 'with valid attributes' do
        it 'redirects to users' do
          sign_in(user_admin_to_login)

          post '/users', params: { user: valid_attributes }
          expect(response).to redirect_to(users_url)
        end
      end

      context 'with invalid attributes' do
        it 'redirects to users' do
          sign_in(user_admin_to_login)

          post '/users', params: { user: { name: 'xpto' } }
          expect(response).to redirect_to(new_user_url)
        end
      end
    end

    context 'without a valid login' do
      it 'redirects to users sign in' do
        post '/users', params: { user: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
