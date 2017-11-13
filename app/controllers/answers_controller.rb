class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update, :destroy, :set_as_best]

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        format.js
        format.json { render json: @answer }
      else
        format.js
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = "Your answer was successfully destroy."
    else
      flash.now[:notice] = "You can't delete that answer"
    end
  end

  def set_as_best
    @answer.set_as_best if current_user.author_of?(@answer.question)
    @answers = @answer.question.answers
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end
end
