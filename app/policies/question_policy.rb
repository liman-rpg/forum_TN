class QuestionPolicy < ApplicationPolicy
  include VotePolicy
  
  def index?
    true
  end
end
