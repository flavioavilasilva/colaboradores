# frozen_string_literal: true

# Class provides access controller with cancan lib
class Ability
  include CanCan::Ability

  def initialize(user)
    if user&.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
