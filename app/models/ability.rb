class Ability
  include CanCan::Ability

  def initialize(user)
    can [:show], Product
    return if user.blank?
    return can :manage, :all if user.admin?
    # customer logged in
    can [:show, :edit, :update, :change_password, :update_password], User
    can [:index, :new, :create], Order
    can :create, Review
    can :update, Review, user_id: user.id
    can [:new, :create], Suggestion
  end
end
