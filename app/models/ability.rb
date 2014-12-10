class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?
    can :manage, Loan, :user_id => user.id
    can :manage, Investment, :user_id => user.id
  end
end
