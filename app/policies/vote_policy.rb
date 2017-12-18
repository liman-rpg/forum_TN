module VotePolicy
  def vote?
    user? && !owner?
  end

  def vote_remove?
    vote && owner?(vote)
  end

  private

  def vote
    @vote ||= record.votes.find_by(user_id: user.id)
  end
end
