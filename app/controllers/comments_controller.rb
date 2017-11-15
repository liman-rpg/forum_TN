class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params.merge(user_id: current_user.id))
    @comment.save
  end

  private

  def commentable
    params[:commentable]
  end

  def load_commentable
    @commentable = commentable.classify.constantize.find(params["#{commentable}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
