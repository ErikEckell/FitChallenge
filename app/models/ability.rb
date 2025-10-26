class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    if user.admin?
      can :manage, :all
    elsif user.creator?
      can :read, :all
      can [:create, :update], Challenge
      can [:update, :destroy], Challenge, creator_id: user.id
      # más reglas según necesites
    else
      can :read, :all
    end
  end
end
