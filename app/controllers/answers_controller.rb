class AnswersController < ApplicationController
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update]

  def new
    @answer = Answer.new
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def update
    if
      @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
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
