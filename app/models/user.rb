# frozen_string_literal: true

# User model
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :role
  validates :name, presence: true
  after_initialize :assign_role

  def assign_role
    self.role = Role.find_by(name: 'Regular') if role.blank?
  end

  def admin?
    role.name.capitalize == 'Admin'
  end

  def self.search_by(query)
    return order(:name, :asc) if query.nil?

    return joins(:role).where('role.name': query[:role_name]).order('role.name', :asc) if search_by_role?(query)

    where(query).order(query.keys, :asc)
  end

  def self.search_by_role?(query)
    query.keys.include?('role_name') || query.keys.include?(:role_name)
  end
end
