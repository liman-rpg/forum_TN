module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: :vote_up
    before_action :status_no_content, only: :vote_up
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { id: @votable.id, score: @votable.total_score }
  end

  private

  def get_votable
    @votable = model_klass.find(params[:id])
  end

  def status_no_content
    if current_user.author_of?(@votable)
      head :no_content
    end
  end

  def model_klass
    controller_name.classify.constantize
  end
end
