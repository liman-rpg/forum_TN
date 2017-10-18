class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update, :destroy]

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if @answer.update(answer_params)
      flash[:notice] = "Your answer was successfully updated."
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = "Your answer was successfully destroy."
    else
      flash[:notice] = "You can't delete that answer"
    end
    redirect_to question_path(@answer.question)
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
