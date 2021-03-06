class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :answers]

  def index
    @questions = Question.all
    authorize @questions
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  def create
    authorize Question.new
    respond_with(@question = current_resource_owner.questions.create(question_params))
  end

  def answers
    @answers = @question.answers
    respond_with @answers
  end

  private

  def load_question
    @question = Question.find(params[:id])
    authorize @question
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
