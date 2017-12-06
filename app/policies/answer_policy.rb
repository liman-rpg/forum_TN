class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    true
  end

  def vote?
    user? && !owner?
  end

  def set_as_best?
    owner?(record.question)
  end
end
