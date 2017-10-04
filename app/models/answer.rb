class Answer < ApplicationRecord
  belongs_to :question

  validates :body,length: { minimum: 5 }, presence: true
end
