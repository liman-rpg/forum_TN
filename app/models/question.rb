class Question < ApplicationRecord
  validates :title, :body, presence: true
  validates :body, length: { minimum: 5 }
end
