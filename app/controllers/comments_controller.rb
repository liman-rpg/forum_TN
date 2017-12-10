class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :load_commentable
  after_action :publish_comment, only: :create

  respond_to :js, only: :create

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  private

  def publish_comment
    return if @comment.errors.any?
    klass = @commentable.class.name
    question_id = (klass == 'Question' ? @commentable.id : @commentable.question_id)

    ActionCable.server.broadcast(
      "questions/#{question_id}/comments",
      @comment.to_json
    )
  end

  def commentable
    params[:commentable]
  end

  def load_commentable
    @commentable = commentable.classify.constantize.find(params["#{commentable}_id"])
    authorize @commentable
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

end
