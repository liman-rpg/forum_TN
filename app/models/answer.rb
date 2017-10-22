class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 5 }, presence: true

  default_scope { order(best: :desc) }

  def set_as_best
    Answer.transaction do
      question.answers.update_all(best: false)
      self.update!(best: true) unless best
    end
  end
end
