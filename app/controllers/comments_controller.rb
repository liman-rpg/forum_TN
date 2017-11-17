class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :load_commentable
  after_action :publish_comment, only: :create

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

  def publish_comment
    return if @comment.errors.any?
    # klass = @commentable.class.name
    # question_id = (klass == 'Question' ? @commentable.id : @commentable.question_id)

    if params['question_id'].present?
      question_id = params['question_id']
    else
      question_id = @comment.commentable.question_id
    end

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
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

end
