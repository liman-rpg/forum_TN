module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    self.votes.create(score: 1, user: user)
  end

  def vote_down(user)
    self.votes.create(score: -1, user: user)
  end

  def total_score
    self.votes.sum(:score)
  end
end
