class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @comment.save
        format.js
        format.json { render json: @comment }
      else
        format.js
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
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
