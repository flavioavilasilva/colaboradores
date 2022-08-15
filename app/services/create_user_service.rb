# frozen_string_literal: true

# Create user service with flexible welcome email options
class CreateUserService
  attr_accessor :user_params, :send_email_assync

  def initialize(user_params)
    @user_params = user_params
    @send_email_assync = send_email_assync
  end

  def call
    user = User.new(user_params)

    UserMailer.with(user: user).welcome_email.deliver_later if user.save
    user
  end
end
