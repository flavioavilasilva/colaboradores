# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do
  describe 'GET /index' do
    context 'with a valid login' do
      let(:user_to_login) { create(:user, name: 'Adailton', email: 'adailton@provedor.com') }
      let(:return_list_users) { [create(:user, name: 'Zileide', email: 'zileide@provedor.com')] }

      before do
        user_to_login
        return_list_users
        expect_any_instance_of(SearchUsersService).to receive(:call).and_return([return_list_users])
      end

      it 'renders a successful response ans redirect to users' do
        sign_in(user_to_login)

        get users_url
        expect(response).to be_successful
      end
    end

    context 'without a valid login' do
      it 'redirects and status 302' do
        get users_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
