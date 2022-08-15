# frozen_string_literal: true

# This class provides welcome method to user
class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Cadastro efetuado com sucesso!')
  end
end
