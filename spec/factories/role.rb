# frozen_string_literal: true

# This will class the Role class
FactoryBot.define do
  factory :role do
    name { 'Admin' }
    description { 'Can do all' }
  end
end
