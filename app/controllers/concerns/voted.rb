module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [:vote_up, :vote_down, :vote_cancel]
    before_action :author_of?, only: [:vote_up, :vote_down]
  end

  def vote_up
    authorize @votable, :vote?
    @votable.vote_up(current_user)
    render json: { id: @votable.id, score: @votable.total_score, status: true, type: "#{model_klass}" }
  end

  def vote_down
    authorize @votable, :vote?
    @votable.vote_down(current_user)
    render json: { id: @votable.id, score: @votable.total_score, status: true, type: "#{model_klass}" }
  end

  def vote_cancel
    authorize @votable, :vote_remove?
    return head :forbidden unless current_user? || rate_exists?
    @votable.vote_cancel(current_user)
    render json: { id: @votable.id, score: @votable.total_score, status: false, type: "#{model_klass}" }
    # authorize @votable, :vote_remove?
    # @votable.vote_cancel!(current_user)
    # render json: json_data(true)
    # render json: { id: @votable.id, score: @votable.total_score, status: false, type: "#{model_klass}" }
  end

  private

  def get_votable
    @votable = model_klass.find(params[:id])
    # @votable = controller_name.classify.constantize.find(params[:id])
  end

  def author_of?
    if current_user.author_of?(@votable)
      head :forbidden
    end
  end

  def current_user?
    @votable.user_id == current_user.id
  end

  def rate_exists?
    Vote.exists?(votable: @votable, user_id: current_user.id)
  end

  def model_klass
    controller_name.classify.constantize
  end
end
