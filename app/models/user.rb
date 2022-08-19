# frozen_string_literal: true

# User model
class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  belongs_to :role
  validates :name, presence: true
  # after_create_commit :send_welcome_email

  after_initialize :assign_role

  # def send_welcome_email
  #   UserMailer.with(self).welcome_email.deliver_later
  # end

  def assign_role
    self.role ||= Role.find_by(name: 'Regular') if role.blank?
  end

  def admin?
    role.name.capitalize == 'Admin'
  end
end
