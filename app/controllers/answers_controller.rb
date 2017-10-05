class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def edit
    @answer = Answer.find(params[:id])
  end
end
