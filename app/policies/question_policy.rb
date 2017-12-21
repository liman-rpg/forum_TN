class QuestionPolicy < ApplicationPolicy
  include VotePolicy

  def index?
    true
  end

  def answers?
    show?
  end
end
