class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 5 }, presence: true

  def set_as_best
    question.answers.update_all(best: false)
    self.update!(best: true)
  end
end
