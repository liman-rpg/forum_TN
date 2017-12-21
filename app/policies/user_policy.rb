class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def me?
    show?
  end
end
