class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: :create

  respond_to :js, only: :update

  def index
    respond_with(@questions = policy_scope(Question.all))
  end

  def show
    @answer = Answer.new
    @answers = @question.answers
    gon.question_id = @question.id
    respond_with @question
  end

  def new
    @question = Question.new
    @question.attachments.build
    respond_with authorize @question
  end

  def edit
  end

  def create
    authorize Question.new
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

    def publish_question
      return if @question.errors.any?
      ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
          partial: 'questions/question_link',
          locals: { question: @question }
        )
      )
    end

    def load_question
      @question = Question.find(params[:id])
      authorize @question
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end
end
