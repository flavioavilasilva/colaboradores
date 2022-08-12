# frozen_string_literal: true

# This will guess the User class
FactoryBot.define do
  factory :user do
    name { 'John' }
    email { 'john@provedor.com' }
    password { '123456' }
    password_confirmation { '123456' }
    role { create(:role) }
  end
end
