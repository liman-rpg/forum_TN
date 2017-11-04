module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :author_of?, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { id: @votable.id, score: @votable.total_score, status: true }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { id: @votable.id, score: @votable.total_score, status: true }
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    render json: { id: @votable.id, score: @votable.total_score, status: false }
  end

  private

  def get_votable
    @votable = model_klass.find(params[:id])
  end

  def author_of?
    if current_user.author_of?(@votable)
      head :forbidden
    end
  end

  def model_klass
    controller_name.classify.constantize
  end
end
