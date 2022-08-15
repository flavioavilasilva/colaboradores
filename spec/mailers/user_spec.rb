# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'welcome_email' do
    let(:mail) { UserMailer.with(user: create(:user, email: 'john@provedor.com')).welcome_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Cadastro efetuado com sucesso!')
      expect(mail.to).to eq(['john@provedor.com'])
      expect(mail.from).to eq(['notifications@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Welcome to example.com, John')
    end
  end
end
