module VotePolicy
  def vote?
    user? && !owner?
  end

  def vote_remove?
    owner?(vote)
  end

  private

  def vote
    record.votes.find_by(user_id: user.id)
  end
end
