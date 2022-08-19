# frozen_string_literal: true

# Create user service with flexible welcome email options
class CreateUserService
  attr_accessor :user_params

  def initialize(user_params)
    @user_params = user_params
  end

  def call
    user = User.new(user_params)

    begin
      UserMailer.with(user: user).welcome_email.deliver_later if user.save
    rescue Redis::CannotConnectError
      # here is a good idea notification the error to airbrake or something like
      puts 'Redis connection error'
    end

    user
  end
end
