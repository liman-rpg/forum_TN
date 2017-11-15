class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def create
    @comment = @question.comments.new(comment_params.merge(user_id: current_user.id))
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
