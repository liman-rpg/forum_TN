class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update, :destroy, :set_as_best]

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def set_as_best
    @answer.set_as_best if current_user.author_of?(@answer.question)
    redirect_to @answer.question
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
