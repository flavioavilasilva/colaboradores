# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateUserService, type: :service do
  include ActiveJob::TestHelper

  context 'when has valid atributes to user' do
    let(:role) { create(:role) }
    let(:user_params) do
      {
        name: 'Flavio Avila',
        email: 'flavio.avila.silva@outlook.com',
        password: '123456',
        password_confirmation: '123456',
        role_id: role.id
      }
    end

    subject { CreateUserService.new(user_params).call }

    it 'create the user and send the welcome e-mail' do
      clear_enqueued_jobs
      subject

      user = User.find_by(email: user_params[:email])
      expect(user).not_to be_nil
      expect(enqueued_jobs.size).to eq(1)
    end
  end

  context 'when UserMailer raise error Redis::CannotConnectError' do
    let(:role) { create(:role) }
    let(:user_params) do
      {
        name: 'Flavio Avila',
        email: 'flavio.avila.silva@outlook.com',
        password: '123456',
        password_confirmation: '123456',
        role_id: role.id
      }
    end

    before do
      allow(UserMailer).to receive(:welcome_email).and_raise(Redis::CannotConnectError)
      clear_enqueued_jobs
    end

    subject { CreateUserService.new(user_params).call }

    it 'create the user and but not send the e-mail' do
      subject

      user = User.find_by(email: user_params[:email])
      expect(user).not_to be_nil
    end
  end
end
