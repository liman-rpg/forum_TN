class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: [:show]
  before_action :load_question, only: [:create]

  def show
    respond_with @answer
  end

  def create
    authorize Answer.new
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id)))
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
    authorize @answer
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
