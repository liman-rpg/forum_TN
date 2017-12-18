class AnswerPolicy < ApplicationPolicy
  include VotePolicy
  
  def index?
    true
  end

  def set_as_best?
    owner?(record.question)
  end
end
