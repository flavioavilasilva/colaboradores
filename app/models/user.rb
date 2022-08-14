# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :role
  validates :name, presence: true
  before_save :assign_role

  def assign_role
    self.role = Role.find_by name: 'Regular' if role.nil?
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
