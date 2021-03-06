class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:edit, :create, :update, :destroy]
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update, :destroy, :set_as_best]
  after_action :publish_answer, only: :create

  respond_to :js, only: [:create, :update, :destroy, :set_as_best]
  respond_to :json, only: :create

  def edit
  end

  def create
    authorize Answer.new
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_as_best
    @answers = @answer.question.answers
    respond_with(@answer.set_as_best)
  end

  private

    def publish_answer
      return if @answer.errors.any?
      ActionCable.server.broadcast(
        "questions/#{@question.id}",
        ApplicationController.render(
          partial: 'answers/create.json.jbuilder',
          locals: { answer: @answer },
        )
      )
    end

    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
      authorize @answer
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end
end
